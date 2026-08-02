# frozen_string_literal: true

module Idml
  module Render
    # Minimal PDF file writer. Assembles content-stream strings into
    # a valid PDF with page tree, font resources, cross-reference
    # table, and trailer. Uses base-14 fonts (no embedding needed).
    class PdfWriter
      def initialize
        @pages = []
        @next_id = 1
        @catalog_id = alloc_id
        @pages_id = alloc_id
      end

      def add_page(width:, height:, content:, fonts: {})
        font_objs = build_fonts(fonts)
        content_id = alloc_id
        page_id = alloc_id

        @pages << {
          id: page_id,
          width: width,
          height: height,
          content_id: content_id,
          content: content,
          font_objs: font_objs,
        }
        page_id
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
          font_id = alloc_id
          { name: name, ps_name: ps_name, id: font_id }
        end
      end

      def build_pdf
        objects = {}

        # Catalog
        objects[@catalog_id] = "<< /Type /Catalog /Pages #{@pages_id} 0 R >>"

        # Pages tree
        page_refs = @pages.map { |p| "#{p[:id]} 0 R" }.join(" ")
        objects[@pages_id] =
          "<< /Type /Pages /Kids [#{page_refs}] /Count #{@pages.length} >>"

        # Each page, its content stream, and fonts
        @pages.each do |page|
          font_dict = page[:font_objs].map do |f|
            "/#{f[:name]} #{f[:id]} 0 R"
          end.join(" ")
          objects[page[:id]] = build_page_object(page, font_dict)
          objects[page[:content_id]] = build_content_stream(page[:content])
          page[:font_objs].each do |f|
            objects[f[:id]] = build_font_object(f[:ps_name])
          end
        end

        assemble_pdf(objects)
      end

      def build_page_object(page, font_dict)
        "<< /Type /Page /Parent #{@pages_id} 0 R " \
          "/MediaBox [0 0 #{page[:width]} #{page[:height]}] " \
          "/Contents #{page[:content_id]} 0 R " \
          "/Resources << /Font << #{font_dict} >> >> >>"
      end

      def build_content_stream(content)
        "<< /Length #{content.bytesize} >>\nstream\n#{content}\nendstream"
      end

      def build_font_object(ps_name)
        "<< /Type /Font /Subtype /Type1 /BaseFont /#{ps_name} >>"
      end

      def assemble_pdf(objects)
        pdf = +"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n"
        offsets = {}
        (1...@next_id).each do |id|
          next unless objects[id]

          offsets[id] = pdf.bytesize
          pdf << "#{id} 0 obj\n#{objects[id]}\nendobj\n"
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
    end
  end
end
