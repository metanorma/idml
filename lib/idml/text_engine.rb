# frozen_string_literal: true

module Idml
  # Pure-Ruby text layout engine. Takes styled text runs + frame
  # geometry and produces positioned glyphs using font metrics from
  # .ttf/.otf files. IDML-agnostic — works on any styled text.
  module TextEngine
    autoload :FontMetrics,     "#{__dir__}/text_engine/font_metrics"
    autoload :FontResolver,    "#{__dir__}/text_engine/font_resolver"
    autoload :Shaper,          "#{__dir__}/text_engine/shaper"
    autoload :ShapedGlyph,     "#{__dir__}/text_engine/shaper"
    autoload :LineBreaker,     "#{__dir__}/text_engine/line_breaker"
    autoload :Line,            "#{__dir__}/text_engine/line_breaker"
    autoload :Justifier,       "#{__dir__}/text_engine/justifier"
    autoload :VerticalLayout,  "#{__dir__}/text_engine/vertical_layout"
    autoload :PositionedGlyph, "#{__dir__}/text_engine/vertical_layout"
    autoload :CjkLayout,       "#{__dir__}/text_engine/cjk_layout"
  end
end
