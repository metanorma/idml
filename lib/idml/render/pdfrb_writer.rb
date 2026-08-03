# frozen_string_literal: true

require "pdfrb"
require "stringio"

module Idml
  module Render
    # Adapter wrapping Pdfrb::Document for IDML→PDF rendering.
    # Replaces the hand-rolled PdfWriter with pdfrb's spec-compliant
    # PDF assembly. Renderers receive a Canvas and call drawing
    # methods directly.
    class PdfrbWriter
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      INFO_SETTERS = {
        Title: :title=,
        Author: :author=,
        Subject: :subject=,
        Keywords: :keywords=,
        Creator: :creator=,
        Producer: :producer=,
        CreationDate: :creationdate=,
        ModDate: :moddate=,
      }.freeze

      def initialize
        @document = Pdfrb::Document.new
        @image_names = {}
      end

      def add_page(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT)
        page = @document.pages.add
        page[:MediaBox] = [0, 0, width, height]
        page.canvas
      end

      def set_info(hash)
        meta = @document.metadata
        hash.each do |key, value|
          setter = INFO_SETTERS[key.to_sym]
          next unless setter

          meta.public_send(setter, value.to_s)
        end
      end

      # Register an image from binary data. Returns the resource name
      # (e.g., :Im1) for use with draw_image.
      def add_image(data:)
        io = StringIO.new(data.dup.force_encoding("ASCII-8BIT"))
        @document.images.add(io)
      end

      # Find a registered image by its source URI (for deduplication).
      def image_name_for(uri)
        @image_names[uri]
      end

      # Cache an image name for a given URI.
      def register_image_name(uri, name)
        @image_names[uri] = name
      end

      # Draw a registered image XObject on a canvas at the given
      # position with the given scale. Uses the Do operator via
      # PdfrbExt::InvokeXObject.
      def draw_image(canvas, name, x:, y:, scale_x:, scale_y:)
        canvas.save_graphics_state do
          canvas.concat(scale_x, 0, 0, scale_y, x, y)
          canvas.emit_op(PdfrbExt::InvokeXObject, name)
        end
      end

      def write(path)
        @document.write(path)
      end

      def document
        @document
      end

      # Register a TrueType/OpenType font file. Returns the resource
      # name (e.g., :F1) for use in canvas.text(font: name).
      def register_font(path)
        @document.fonts.add(path)
      end

      # Add a bookmark (outline entry) pointing to a page.
      # title: display text; page_index: 0-based page index.
      def add_bookmark(title, page_index)
        page = @document.pages[page_index]
        @document.outline.add(title, dest: page)
      end
    end
  end
end
