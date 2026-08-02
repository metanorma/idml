# frozen_string_literal: true

module Idml
  module Render
    autoload :Color,            "#{__dir__}/render/color"
    autoload :Path,             "#{__dir__}/render/path"
    autoload :Text,             "#{__dir__}/render/text"
    autoload :Image,            "#{__dir__}/render/image"
    autoload :FontEmbedder,     "#{__dir__}/render/font_embedder"
    autoload :ColorResolver,    "#{__dir__}/render/color_resolver"
    autoload :StyleResolver,    "#{__dir__}/render/style_resolver"
    autoload :FontReferenceResolver,
             "#{__dir__}/render/font_reference_resolver"
    autoload :GradientResolver, "#{__dir__}/render/gradient_resolver"
    autoload :LayerFilter,      "#{__dir__}/render/layer_filter"
    autoload :StoryThreader,    "#{__dir__}/render/story_threader"
    autoload :PdfWriter,        "#{__dir__}/render/pdf_writer"
    autoload :SpreadRenderer,   "#{__dir__}/render/spread_renderer"
    autoload :Pipeline,         "#{__dir__}/render/pipeline"
    autoload :RenderContext,    "#{__dir__}/render/render_context"
    autoload :PageItemRenderer, "#{__dir__}/render/page_item_renderer"
    autoload :Renderers,        "#{__dir__}/render/renderers"

    DEFAULT_FONT = "Helvetica"

    def self.render(package:, to:, font_search_paths: nil)
      Pipeline.new(package, to, font_search_paths).call
    end
  end
end

Idml::Render::Renderers.autoload(
  :RectangleRenderer,
  "#{__dir__}/render/renderers/rectangle_renderer",
)
Idml::Render::Renderers.autoload(
  :TextFrameRenderer,
  "#{__dir__}/render/renderers/text_frame_renderer",
)
Idml::Render::Renderers.autoload(
  :PolygonRenderer,
  "#{__dir__}/render/renderers/polygon_renderer",
)
Idml::Render::Renderers.autoload(
  :GraphicLineRenderer,
  "#{__dir__}/render/renderers/graphic_line_renderer",
)
Idml::Render::Renderers.autoload(
  :GroupRenderer,
  "#{__dir__}/render/renderers/group_renderer",
)
Idml::Render::Renderers.autoload(
  :TableRenderer,
  "#{__dir__}/render/renderers/table_renderer",
)
