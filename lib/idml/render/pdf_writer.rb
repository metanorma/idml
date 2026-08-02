# frozen_string_literal: true

module Idml
  module Render
    # Minimal PDF file writer. Assembles content-stream strings into
    # a valid PDF with page tree, font resources, image XObjects,
    # embedded TrueType fonts, cross-reference table, and trailer.
    class PdfWriter
      def initialize
        @pages = []
        @images = {}
        @embedded_fonts = {}
        @info = {}
        @next_id = 1
        @catalog_id = alloc_id
        @pages_id = alloc_id
        @info_id = alloc_id
      end

      def add_page(width:, height:, content:, fonts: {}, xobjects: [])
        font_objs = build_fonts(fonts)
        xobject_objs = build_xobjects(xobjects)
        content_id = alloc_id
        page_id = alloc_id

        @pages << {
          id: page_id,
          width: width,
          height: height,
          content_id: content_id,
          content: content,
          font_objs: font_objs,
          xobject_objs: xobject_objs,
        }
        page_id
      end

      # Register a JPEG image as a PDF image XObject (DCTDecode).
      # Returns the XObject name to use in content streams (e.g. "Im1").
      def add_jpeg_image(data:, width:, height:, colorspace: :DeviceRGB)
        add_image_object(data: data, width: width, height: height,
                         colorspace: colorspace, filter: :DCTDecode)
      end

      # Register a PNG image as a PDF image XObject (FlateDecode with
      # PNG predictor). The IDAT chunk data is embedded directly; the
      # PDF viewer handles decompression and unfiltering.
      def add_png_image(data:, width:, height:, colorspace: :DeviceRGB)
        idat = Render::Image.png_idat_data(data)
        return nil unless idat

        name = add_image_object(data: idat, width: width, height: height,
                                colorspace: colorspace, filter: :FlateDecode)
        @images[name][:decode_parms] = png_decode_parms(width, colorspace)
        name
      end

      # Auto-detect format and register the image.
      def add_image(data:)
        format = Render::Image.detect_format(data)
        return nil unless format

        dims = image_dimensions(data, format)
        return nil unless dims

        cs = image_colorspace(data, format) || :DeviceRGB
        register_format_image(data, format, dims, cs)
      end

      def image_dimensions(data, format)
        if format == :png
          Render::Image.png_dimensions(data)
        else
          Render::Image.jpeg_dimensions(data)
        end
      end

      def image_colorspace(data, format)
        if format == :png
          Render::Image.png_colorspace(data)
        else
          Render::Image.jpeg_colorspace(data)
        end
      end

      def register_format_image(data, format, dims, cs)
        case format
        when :jpeg
          add_jpeg_image(data: data, width: dims[0], height: dims[1],
                         colorspace: cs)
        when :png
          add_png_image(data: data, width: dims[0], height: dims[1],
                        colorspace: cs)
        end
      end

      def add_image_object(data:, width:, height:, colorspace:, filter:)
        name = "Im#{@images.length + 1}"
        id = alloc_id
        @images[name] = {
          id: id,
          data: data.dup.force_encoding("ASCII-8BIT"),
          width: width,
          height: height,
          colorspace: colorspace,
          filter: filter,
        }
        name
      end

      def png_decode_parms(width, colorspace)
        colors = colorspace == :DeviceGray ? 1 : 3
        "<< /Predictor 15 /Columns #{width} /Colors #{colors} /BitsPerComponent 8 >>"
      end

      # Register a TrueType font for embedding (FontFile2). Returns the
      # PostScript name to use as the value in add_page's fonts hash.
      def register_embedded_font(metrics:, data:)
        ps_name = metrics.postscript_name
        @embedded_fonts[ps_name] = {
          metrics: metrics,
          data: data.dup.force_encoding("ASCII-8BIT"),
        }
        ps_name
      end

      def write(path)
        File.binwrite(path, build_pdf)
      end

      # Set PDF metadata (Title, Author, Subject, etc.).
      # Values should be strings; keys are PDF Info dictionary keys.
      def set_info(hash)
        @info.merge!(hash)
      end

      # Add a bookmark (outline entry) pointing to a page.
      # title: display text; page_index: 0-based page index.
      def add_bookmark(title, page_index)
        @outlines ||= []
        @outlines << { title: title, page_index: page_index }
      end

      # Set XMP metadata packet (XML string). Embedded as a stream
      # object referenced from the Catalog.
      def set_xmp(xml)
        @xmp = xml
      end

      # Set OutputIntent with an ICC profile. Required for PDF/A.
      # profile_data: binary ICC profile data.
      def set_output_intent(profile_data)
        @icc_profile = profile_data
      end

      private

      def alloc_id
        id = @next_id
        @next_id += 1
        id
      end

      def build_fonts(fonts)
        fonts.map do |name, ps_name|
          embedded = @embedded_fonts[ps_name]
          entry = {
            name: name,
            ps_name: ps_name,
            id: alloc_id,
            embedded: embedded,
          }
          if embedded
            entry[:descriptor_id] = alloc_id
            entry[:file_id] = alloc_id
          end
          entry
        end
      end

      # xobjects: Array of names referencing registered images.
      def build_xobjects(xobject_names)
        xobject_names.filter_map do |name|
          img = @images[name]
          next unless img

          { name: name, id: img[:id] }
        end
      end

      def build_pdf
        objects = {}

        objects[@catalog_id] = build_catalog(objects)

        page_refs = @pages.map { |p| "#{p[:id]} 0 R" }.join(" ")
        objects[@pages_id] =
          "<< /Type /Pages /Kids [#{page_refs}] /Count #{@pages.length} >>"

        @pages.each { |page| build_page_objects(page, objects) }

        @images.each_value do |img|
          objects[img[:id]] = build_image_xobject(img)
        end

        objects[@info_id] = build_info_object

        assemble_pdf(objects)
      end

      def build_catalog(objects)
        dict = "<< /Type /Catalog /Pages #{@pages_id} 0 R"
        outlines_ref = build_outlines(objects)
        dict << " /Outlines #{outlines_ref}" if outlines_ref
        xmp_ref = build_xmp(objects)
        dict << " /Metadata #{xmp_ref}" if xmp_ref
        output_ref = build_output_intent(objects)
        dict << " /OutputIntents [#{output_ref}]" if output_ref
        "#{dict} >>"
      end

      def build_outlines(objects)
        return nil unless @outlines&.any?

        outlines_id = alloc_id
        item_ids = @outlines.map { alloc_id }
        @outlines.each_with_index do |entry, i|
          objects[item_ids[i]] = outline_item(entry, i, item_ids, outlines_id)
        end
        objects[outlines_id] = outlines_root(outlines_id, item_ids)
        "#{outlines_id} 0 R"
      end

      def outline_item(entry, index, item_ids, outlines_id)
        prev_ref = index.positive? ? " /Prev #{item_ids[index - 1]} 0 R" : ""
        next_ref = next_outline_ref(index, item_ids)
        page_ref = outline_page_ref(entry[:page_index])
        title = escape_pdf_string(entry[:title].to_s)
        "<< /Title (#{title}) /Parent #{outlines_id} 0 R" \
          "#{prev_ref}#{next_ref} /Dest [#{page_ref} 0 R /Fit] >>"
      end

      def next_outline_ref(index, item_ids)
        return "" unless index < item_ids.length - 1

        " /Next #{item_ids[index + 1]} 0 R"
      end

      def outline_page_ref(page_index)
        page = @pages[page_index] || @pages.first
        page ? page[:id] : @pages_id
      end

      def outlines_root(_outlines_id, item_ids)
        "<< /Type /Outlines /First #{item_ids.first} 0 R " \
          "/Last #{item_ids.last} 0 R /Count #{item_ids.length} >>"
      end

      def build_info_object
        entries = @info.map do |key, value|
          "/#{key} (#{escape_pdf_string(value.to_s)})"
        end.join(" ")
        "<< #{entries} >>"
      end

      def escape_pdf_string(str)
        str.gsub("\\", "\\\\\\\\").gsub("(", "\\(").gsub(")", "\\)")
      end

      def build_xmp(objects)
        return nil unless @xmp

        xmp_id = alloc_id
        data = @xmp.dup.force_encoding("ASCII-8BIT")
        objects[xmp_id] = "<< /Type /Metadata /Subtype /XML " \
                          "/Length #{data.bytesize} >>\nstream\n#{data}\nendstream"
        "#{xmp_id} 0 R"
      end

      def build_output_intent(objects)
        return nil unless @icc_profile

        icc_id = alloc_id
        data = @icc_profile.dup.force_encoding("ASCII-8BIT")
        objects[icc_id] = "<< /N 3 /Alternate /DeviceRGB " \
                          "/Length #{data.bytesize} >>\nstream\n#{data}\nendstream"
        intent_id = alloc_id
        objects[intent_id] = "<< /Type /OutputIntent /S /GTS_PDFA1 " \
                             "/OutputConditionIdentifier (sRGB) " \
                             "/Info (sRGB IEC61966-2.1) " \
                             "/DestOutputProfile #{icc_id} 0 R >>"
        "#{intent_id} 0 R"
      end

      def build_page_objects(page, objects)
        font_dict = page[:font_objs].map do |f|
          "/#{f[:name]} #{f[:id]} 0 R"
        end.join(" ")
        xobject_dict = page[:xobject_objs].map do |x|
          "/#{x[:name]} #{x[:id]} 0 R"
        end.join(" ")
        objects[page[:id]] = build_page_object(page, font_dict, xobject_dict)
        objects[page[:content_id]] = build_content_stream(page[:content])
        page[:font_objs].each do |f|
          if f[:embedded]
            build_embedded_font_objects(f, objects)
          else
            objects[f[:id]] = build_type1_font(f[:ps_name])
          end
        end
      end

      def build_embedded_font_objects(f, objects)
        metrics = f[:embedded][:metrics]
        data = f[:embedded][:data]
        desc = Render::FontEmbedder.descriptor(metrics)
        widths = Render::FontEmbedder.widths_array(metrics)

        objects[f[:id]] = build_truetype_font(f, desc, widths)
        objects[f[:descriptor_id]] = build_font_descriptor(desc, f[:file_id])
        objects[f[:file_id]] = build_fontfile2(data)
      end

      def build_page_object(page, font_dict, xobject_dict)
        resources = "<< /Font << #{font_dict} >>"
        resources << " /XObject << #{xobject_dict} >>" unless xobject_dict.empty?
        resources << " >>"
        "<< /Type /Page /Parent #{@pages_id} 0 R " \
          "/MediaBox [0 0 #{page[:width]} #{page[:height]}] " \
          "/Contents #{page[:content_id]} 0 R " \
          "/Resources #{resources} >>"
      end

      def build_content_stream(content)
        "<< /Length #{content.bytesize} >>\nstream\n#{content}\nendstream"
      end

      def build_type1_font(ps_name)
        "<< /Type /Font /Subtype /Type1 /BaseFont /#{ps_name} >>"
      end

      def build_truetype_font(f, desc, widths)
        "<< /Type /Font /Subtype /TrueType " \
          "/BaseFont /#{desc[:font_name]} " \
          "/FirstChar #{Render::FontEmbedder::FIRST_CHAR} " \
          "/LastChar #{Render::FontEmbedder::LAST_CHAR} " \
          "/Widths [#{widths.join(' ')}] " \
          "/FontDescriptor #{f[:descriptor_id]} 0 R " \
          "/Encoding /WinAnsiEncoding >>"
      end

      def build_font_descriptor(desc, file_id)
        bbox = desc[:font_bbox].join(" ")
        "<< /Type /FontDescriptor /FontName /#{desc[:font_name]} " \
          "/Flags #{desc[:flags]} " \
          "/FontBBox [#{bbox}] " \
          "/ItalicAngle #{desc[:italic_angle]} " \
          "/Ascent #{desc[:ascent]} /Descent #{desc[:descent]} " \
          "/CapHeight #{desc[:cap_height]} /StemV #{desc[:stem_v]} " \
          "/FontFile2 #{file_id} 0 R >>"
      end

      def build_fontfile2(data)
        result = String.new(encoding: "ASCII-8BIT")
        result << "<< /Length #{data.bytesize} /Length1 #{data.bytesize} >>\n"
        result << "stream\n"
        result << data
        result << "\nendstream"
        result
      end

      def build_image_xobject(img)
        data = img[:data]
        filter = img[:filter] || :DCTDecode
        result = String.new(encoding: "ASCII-8BIT")
        result << "<< /Type /XObject /Subtype /Image /Width #{img[:width]} "
        result << "/Height #{img[:height]} /BitsPerComponent 8 "
        result << "/ColorSpace /#{img[:colorspace]} /Filter /#{filter} "
        if img[:decode_parms]
          result << "/DecodeParms #{img[:decode_parms]} "
        end
        result << "/Length #{data.bytesize} >>\nstream\n"
        result << data
        result << "\nendstream"
        result
      end

      def assemble_pdf(objects)
        pdf = "%PDF-1.4\n%\xe2\xe3\xcf\xd3\n".b
        offsets = {}
        (1...@next_id).each do |id|
          next unless objects[id]

          offsets[id] = pdf.bytesize
          pdf << "#{id} 0 obj\n"
          pdf << to_binary(objects[id])
          pdf << "\nendobj\n"
        end
        xref_pos = pdf.bytesize
        pdf << "xref\n0 #{@next_id}\n0000000000 65535 f \n"
        (1...@next_id).each do |id|
          pdf << if offsets[id]
                   format("%010d 00000 n \n", offsets[id])
                 else
                   "0000000000 65535 f \n"
                 end
        end
        pdf << "trailer\n<< /Size #{@next_id} /Root #{@catalog_id} 0 R " \
               "/Info #{@info_id} 0 R >>\n"
        pdf << "startxref\n#{xref_pos}\n%%EOF"
        pdf
      end

      def to_binary(str)
        return str if str.encoding == Encoding::ASCII_8BIT

        str.dup.force_encoding("ASCII-8BIT")
      end
    end
  end
end
