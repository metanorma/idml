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
        @next_id = 1
        @catalog_id = alloc_id
        @pages_id = alloc_id
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
        name = "Im#{@images.length + 1}"
        id = alloc_id
        @images[name] = {
          id: id,
          data: data.dup.force_encoding("ASCII-8BIT"),
          width: width,
          height: height,
          colorspace: colorspace,
        }
        name
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

        objects[@catalog_id] = "<< /Type /Catalog /Pages #{@pages_id} 0 R >>"

        page_refs = @pages.map { |p| "#{p[:id]} 0 R" }.join(" ")
        objects[@pages_id] =
          "<< /Type /Pages /Kids [#{page_refs}] /Count #{@pages.length} >>"

        @pages.each { |page| build_page_objects(page, objects) }

        @images.each_value do |img|
          objects[img[:id]] = build_image_xobject(img)
        end

        assemble_pdf(objects)
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
        result = String.new(encoding: "ASCII-8BIT")
        result << "<< /Type /XObject /Subtype /Image /Width #{img[:width]} "
        result << "/Height #{img[:height]} /BitsPerComponent 8 "
        result << "/ColorSpace /#{img[:colorspace]} /Filter /DCTDecode "
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
        pdf << "trailer\n<< /Size #{@next_id} /Root #{@catalog_id} 0 R >>\n"
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
