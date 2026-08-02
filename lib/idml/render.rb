# frozen_string_literal: true

module Idml
  module Render
    autoload :Color,          "#{__dir__}/render/color"
    autoload :Path,           "#{__dir__}/render/path"
    autoload :Text,           "#{__dir__}/render/text"
    autoload :PdfWriter,      "#{__dir__}/render/pdf_writer"
    autoload :SpreadRenderer, "#{__dir__}/render/spread_renderer"
    autoload :Pipeline,       "#{__dir__}/render/pipeline"

    DEFAULT_FONT = "Helvetica"

    def self.render(package:, to:, font_search_paths: nil)
      Pipeline.new(package, to, font_search_paths).call
    end
  end
end
