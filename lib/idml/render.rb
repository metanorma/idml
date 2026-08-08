# frozen_string_literal: true

require "pdfrb"

module Idml
  module Render
    autoload :ColorHelper,         "#{__dir__}/render/color_helper"
    autoload :Image,               "#{__dir__}/render/image"
    autoload :ColorResolver,       "#{__dir__}/render/color_resolver"
    autoload :StyleResolver,       "#{__dir__}/render/style_resolver"
    autoload :FontReferenceResolver,
             "#{__dir__}/render/font_reference_resolver"
    autoload :GradientResolver,    "#{__dir__}/render/gradient_resolver"
    autoload :Blending,            "#{__dir__}/render/blending"
    autoload :StrokeStyle,         "#{__dir__}/render/stroke_style"
    autoload :CharacterStyle,      "#{__dir__}/render/character_style"
    autoload :LayerFilter,         "#{__dir__}/render/layer_filter"
    autoload :Placement,           "#{__dir__}/render/placement"
    autoload :ImageCollector,      "#{__dir__}/render/image_collector"
    autoload :StructureTracker,    "#{__dir__}/render/structure_tracker"
    autoload :StructureMapper,     "#{__dir__}/render/structure_mapper"
    autoload :PdfaPacket,          "#{__dir__}/render/pdfa_packet"
    autoload :IccProfile,          "#{__dir__}/render/icc_profile"
    autoload :BookmarkResolver,    "#{__dir__}/render/bookmark_resolver"
    autoload :HyperlinkResolver,   "#{__dir__}/render/hyperlink_resolver"
    autoload :HyperlinkEmitter,    "#{__dir__}/render/hyperlink_emitter"
    autoload :MetadataBuilder,     "#{__dir__}/render/metadata_builder"
    autoload :FontSetup,           "#{__dir__}/render/font_setup"
    autoload :PositionTracker,     "#{__dir__}/render/position_tracker"
    autoload :StoryThreader,       "#{__dir__}/render/story_threader"
    autoload :PdfrbWriter, "#{__dir__}/render/pdfrb_writer"
    autoload :SpreadRenderer,      "#{__dir__}/render/spread_renderer"
    autoload :Pipeline,            "#{__dir__}/render/pipeline"
    autoload :RenderContext,       "#{__dir__}/render/render_context"
    autoload :PageItemRenderer,    "#{__dir__}/render/page_item_renderer"
    autoload :Renderers,           "#{__dir__}/render/renderers"

    DEFAULT_FONT = "Helvetica"

    # Render an IDML package to a PDF file. All options except
    # `package:` and `to:` are keyword-only and optional.
    # rubocop:disable Metrics/ParameterLists
    def self.render(package:, to:, font_search_paths: nil, compliance: nil,
                   tagged: false, subset_fonts: true, compress: false)
      Pipeline.new(package, to, font_search_paths,
                   compliance: compliance, tagged: tagged,
                   subset_fonts: subset_fonts, compress: compress).call
    end
    # rubocop:enable Metrics/ParameterLists
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
