# frozen_string_literal: true

require "pdfrb"

module Idml
  module Render
    # Adapter wrapping Pdfrb::Document for IDML→PDF rendering.
    # Replaces the hand-rolled PdfWriter with the pdfrb gem's
    # spec-compliant PDF assembly. Renderers receive a Canvas and
    # call drawing methods directly.
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
      end

      def add_page(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT)
        page = @document.pages.add
        # pdfrb defaults to [0, 0, 612, 792] (US Letter). Custom sizes
        # require setting the MediaBox via the COS dictionary.
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

      def write(path)
        @document.write(path)
      end

      def document
        @document
      end
    end
  end
end