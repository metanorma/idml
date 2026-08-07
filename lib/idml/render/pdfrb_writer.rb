# frozen_string_literal: true

module Idml
  module Render
    # Thin adapter wrapping Pdfrb::Document for IDML→PDF rendering.
    # Delegates all PDF assembly to pdfrb (no hand-rolled PDF code).
    # The adapter provides a consistent interface for the Pipeline
    # (add_page → returns Canvas, add_image → name, register_font → name,
    # set_info, add_bookmark, subset_fonts!) while letting pdfrb handle
    # xref, trailer, object streams, and operator emission.
    class PdfrbWriter
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      META_SETTERS = {
        Title: :title=,
        Author: :author=,
        Subject: :subject=,
        Keywords: :keywords=,
        Creator: :creator=,
        Producer: :producer=,
        CreationDate: :creationdate=,
        ModDate: :moddate=,
      }.freeze

      # Lossless writer options applied to the underlying pdfrb
      # Document. Each entry maps a pdfrb config key to its value.
      # Compression (`FlateDecode`), XRef streams, and object-stream
      # packing are all lossless and produce smaller PDFs without
      # throwing away any data — no image downsampling, no font
      # information loss.
      #
      # Compression is **opt-in** because enabling it makes
      # stream-level assertions in specs harder (strings move into
      # compressed ObjStms). Set `compress: true` on the writer or
      # pipeline to enable.
      COMPRESSED_OPTIONS = {
        "writer.compress_streams" => true,
        "writer.compress_min_size" => 64,
        "writer.use_xref_stream" => true,
        "writer.pack_object_streams" => true,
      }.freeze

      def initialize(compress: false)
        config = compress ? COMPRESSED_OPTIONS : {}
        @document = Pdfrb::Document.new(config: config)
        @image_cache = {}
      end

      def add_page(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT)
        page = @document.pages.add
        page.media_box = [0, 0, width, height]
        page.canvas
      end

      def add_image(data:)
        @document.images.add(data)
      end

      def register_font(path)
        @document.fonts.add(File.open(path, "rb"))
      end

      def add_bookmark(title, page_index)
        page = @document.pages[page_index]
        @document.outline.add(title, dest: page)
      end

      def set_info(hash)
        meta = @document.metadata
        hash.each do |key, value|
          setter = META_SETTERS[key.to_sym]
          next unless setter

          meta.public_send(setter, value.to_s)
        end
      end

      def subset_fonts!
        @document.fonts.subset_fonts!
      end

      def write(path)
        @document.write(path)
      end

      def image_name_for(uri)
        @image_cache[uri]
      end

      def register_image_name(uri, name)
        @image_cache[uri] = name
      end

      def enable_tagged
        @document.structure.enable!
      end

      def add_structure_element(type, page_index:, mcid:, text: nil, alt: nil)
        page = @document.pages[page_index]
        @document.structure.add_element(type, text: text, alt: alt,
                                              page: page, mcid: mcid)
      end

      def add_uri_link_annotation(page_index:, rect:, url:)
        page = @document.pages[page_index]
        action = @document.add({ S: :URI, URI: url },
                               type: Pdfrb::Model::Cos::Dictionary)
        action_ref = Pdfrb::Model::Reference.new(action.oid, action.gen)
        annot = @document.annotations.add(page, subtype: :Link, rect: rect)
        annot.value[:A] = action_ref
        annot
      end

      def build_structure
        @document.structure.build!
      end

      def document
        @document
      end
    end
  end
end
