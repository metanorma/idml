# frozen_string_literal: true

module Idml
  module Render
    # Thin adapter wrapping Pdfrb::Document for IDML→PDF rendering.
    # Delegates all PDF assembly to pdfrb (no hand-rolled PDF code).
    # The adapter provides a consistent interface for the Pipeline
    # (add_page → returns Canvas, add_image → name, register_font → name,
    # set_info, add_bookmark) while letting pdfrb handle xref, trailer,
    # object streams, and operator emission.
    class PdfrbWriter
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      def initialize
        @document = Pdfrb::Document.new
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
        @document.fonts.add(path)
      end

      def add_bookmark(title, page_index)
        page = @document.pages[page_index]
        @document.outline.add(title, dest: page)
      end

      def set_info(hash)
        meta = @document.metadata
        hash.each do |key, value|
          setter = META_SETTERS[key.to_sym]
          meta.public_send(setter, value.to_s) if setter
        end
      end

      def write(path)
        @document.write(path)
      end

      def image_name_for(uri)
        @image_cache&.key?(uri) ? @image_cache[uri] : nil
      end

      def register_image_name(uri, name)
        @image_cache ||= {}
        @image_cache[uri] = name
      end

      def document
        @document
      end

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
    end
  end
end
