# frozen_string_literal: true

module Idml
  module Render
    # Embeds linked images (JPEG) as PDF XObjects. Parses the JPEG
    # binary header for width/height, creates an image stream with
    # DCTDecode filter (raw JPEG bytes, no decompression needed).
    module Image
      module_function

      Transform = Struct.new(:a, :b, :c, :d, :e, :f)

      PNG_MAGIC = "\x89PNG\r\n\x1a\n".b
      JPEG_MAGIC_BYTES = [0xFF, 0xD8].freeze

      # Detect image format from magic bytes.
      # Returns :jpeg, :png, or nil.
      def detect_format(data)
        return :jpeg if data.getbyte(0) == 0xFF && data.getbyte(1) == 0xD8
        return :png if data.bytesize >= 8 && data[0, 8] == PNG_MAGIC

        nil
      end

      # Read JPEG dimensions from the binary header.
      # Returns [width, height] or nil if not a valid JPEG.
      def jpeg_dimensions(data)
        find_sof(data) do |_, _, height, width|
          return [width, height]
        end
        nil
      end

      # Detect JPEG color space from binary header.
      # Returns :DeviceRGB (3 channels), :DeviceGray (1), or :DeviceCMYK (4).
      def jpeg_colorspace(data)
        find_sof(data) do |_, _, _, _, channels|
          return case channels
                 when 1 then :DeviceGray
                 when 3 then :DeviceRGB
                 when 4 then :DeviceCMYK
                 end
        end
        nil
      end

      # Walk JPEG markers until SOF is found. Yields marker fields:
      # marker_byte, precision, height, width, channels.
      def find_sof(data)
        return nil unless jpeg_header?(data)

        each_jpeg_marker(data) do |marker, pos|
          next unless sof_marker?(marker)

          yield_sof_fields(data, pos, marker) { |*a| yield(*a) }
          return
        end
        nil
      end

      # Iterate JPEG markers, yielding (marker_byte, data_offset) for each.
      def each_jpeg_marker(data)
        pos = 2
        while pos < data.bytesize - 1
          return unless data.getbyte(pos) == 0xFF

          marker = data.getbyte(pos + 1)
          return if marker.nil? || marker == 0xD9 # EOI

          pos += 4
          length = read_uint16(data, pos - 2)
          return unless length

          yield marker, pos
          pos += length - 2
        end
      end

      def jpeg_header?(data)
        data.getbyte(0) == 0xFF && data.getbyte(1) == 0xD8
      end

      def yield_sof_fields(data, pos, marker)
        precision = data.getbyte(pos)
        height = read_uint16(data, pos + 1)
        width = read_uint16(data, pos + 3)
        channels = data.getbyte(pos + 5)
        yield marker, precision, height, width, channels
      end

      def read_uint16(data, offset)
        return nil if offset.nil? || offset + 1 >= data.bytesize

        (data.getbyte(offset) << 8) | data.getbyte(offset + 1)
      end

      # SOF markers: 0xC0–0xCF except 0xC4 (DHT) and 0xC8 (JPG).
      def sof_marker?(byte)
        byte.between?(0xC0, 0xCF) && byte != 0xC4 && byte != 0xC8
      end

      # Read PNG dimensions from the IHDR chunk.
      # Returns [width, height] or nil if not a valid PNG.
      def png_dimensions(data)
        return nil unless detect_format(data) == :png

        read_png_ihdr(data) do |width, height, _bit_depth, _color_type|
          return [width, height]
        end
        nil
      end

      # Detect PNG color space from the IHDR chunk's color type field.
      # Returns :DeviceRGB, :DeviceGray, or nil.
      def png_colorspace(data)
        return nil unless detect_format(data) == :png

        read_png_ihdr(data) do |_w, _h, _bit_depth, color_type|
          return case color_type
                 when 0, 4 then :DeviceGray
                 when 2, 6 then :DeviceRGB
                 end
        end
        nil
      end

      # Parse PNG IHDR chunk (starts at byte offset 8, after the signature).
      # Yields width, height, bit_depth, color_type.
      def read_png_ihdr(data)
        ihdr_start = 8
        return nil if data.bytesize < ihdr_start + 25

        read_uint32(data, ihdr_start)
        type = data[ihdr_start + 4, 4]
        return nil unless type == "IHDR"

        width = read_uint32(data, ihdr_start + 8)
        height = read_uint32(data, ihdr_start + 12)
        bit_depth = data.getbyte(ihdr_start + 16)
        color_type = data.getbyte(ihdr_start + 17)
        yield width, height, bit_depth, color_type
      end

      def read_uint32(data, offset)
        return nil if offset.nil? || offset + 3 >= data.bytesize

        (data.getbyte(offset) << 24) |
          (data.getbyte(offset + 1) << 16) |
          (data.getbyte(offset + 2) << 8) |
          data.getbyte(offset + 3)
      end

      # Extract concatenated IDAT chunk data from a PNG file.
      # PDF can embed this with FlateDecode + Predictor 15 to let the
      # viewer handle PNG unfiltering during decompression.
      def png_idat_data(data)
        return nil unless detect_format(data) == :png

        result = String.new(encoding: "ASCII-8BIT")
        each_png_chunk(data) do |type, chunk_data|
          break if type == "IEND"

          result << chunk_data if type == "IDAT"
        end
        result.empty? ? nil : result
      end

      # Iterate PNG chunks, yielding (type, data) for each.
      def each_png_chunk(data)
        pos = 8
        while pos + 8 <= data.bytesize
          length = read_uint32(data, pos)
          return unless length

          chunk_type = data[pos + 4, 4]
          pos += 8
          chunk_data = data[pos, length]
          yield chunk_type, chunk_data
          pos += length + 4 # data + CRC
        end
      end

      # Parse "a b c d e f" into a Transform.
      def parse_transform(str)
        parts = str.split(/\s+/).map(&:to_f)
        return nil unless parts.length == 6

        Transform.new(*parts)
      end

      # Combine two transforms: result = outer ∘ inner
      # (outer is applied after inner).
      def combine(outer, inner)
        Transform.new(
          (outer.a * inner.a) + (outer.c * inner.b),
          (outer.b * inner.a) + (outer.d * inner.b),
          (outer.a * inner.c) + (outer.c * inner.d),
          (outer.b * inner.c) + (outer.d * inner.d),
          (outer.a * inner.e) + (outer.c * inner.f) + outer.e,
          (outer.b * inner.e) + (outer.d * inner.f) + outer.f,
        )
      end

      # Extract image references from spread XML. Returns Array of
      # { uri:, transform:, parent_transform: } hashes.
      def extract_from_spread(xml)
        images = []
        pos = 0
        while (img_start = xml.index(/<Image\s/, pos))
          img_end = xml.index(%r{</Image>}, img_start)
          img_end = xml.index("/>", img_start) if img_end.nil?
          break unless img_end

          block = xml[img_start..img_end]
          parent_transform = enclosing_transform(xml, img_start)

          t_match = block.match(/ItemTransform="([^"]+)"/)
          link_match = block.match(/LinkResourceURI="([^"]+)"/)
          if t_match && link_match
            images << {
              uri: link_match[1],
              transform: parse_transform(t_match[1]),
              parent_transform: parent_transform,
            }
          end

          pos = img_end + 1
        end
        images
      end

      # Find the ItemTransform of the nearest enclosing page-item element
      # (Rectangle, Polygon, etc.) before `pos`.
      def enclosing_transform(xml, pos)
        prefix = xml[0...pos]
        tags = %w[Rectangle Polygon Polyline Ellipse GraphicLine Group]
        last_open = tags.filter_map { |tag| prefix.rindex(/<#{tag}\s/) }.max
        return identity unless last_open

        elem = xml[last_open..prefix.length]
        t = elem.match(/ItemTransform="([^"]+)"/)
        return identity unless t

        parse_transform(t[1])
      end

      def identity
        Transform.new(1, 0, 0, 1, 0, 0)
      end

      # Compute the PDF placement for an image given its IDML transforms.
      # IDML uses Y-down; PDF uses Y-up. This flips Y and combines
      # parent + image transforms.
      #
      # Returns { x:, y:, scale_x:, scale_y: } where (x, y) is the
      # bottom-left of the image in PDF page coordinates.
      def compute_placement(image_transform:, parent_transform:,
                            pixel_height:, page_height:,
                            page_transform: nil)
        page_t = page_transform || identity
        combined = combine(page_t, combine(parent_transform, image_transform))

        scale_x = combined.a
        scale_y = combined.d
        idml_x = combined.e
        idml_y = combined.f
        scaled_height = pixel_height * scale_y.abs

        pdf_x = idml_x
        pdf_y = page_height - idml_y - scaled_height

        { x: pdf_x, y: pdf_y, scale_x: scale_x.abs, scale_y: scale_y.abs }
      end

      # Convert a file: URI to a local file path.
      def resolve_path(uri, base_dir: nil)
        path = uri.delete_prefix("file:")
        path = begin
          URI.decode_www_form_component(path)
        rescue StandardError
          path
        end
        path = File.expand_path(path)
        return path if File.exist?(path)

        base_dir ? File.join(base_dir, File.basename(path)) : path
      end

      # DEPRECATED: draw_image is no longer used. pdfrb 0.15.0+ has
      # Canvas#draw_image_matrix for drawing image XObjects with a full
      # affine transform. SpreadRenderer uses it directly.
      def draw_image(*)
        "DEPRECATED"
      end
    end
  end
end
