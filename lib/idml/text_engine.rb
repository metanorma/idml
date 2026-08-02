# frozen_string_literal: true

module Idml
  # Pure-Ruby text layout engine. Takes styled text runs + frame
  # geometry and produces positioned glyphs using font metrics from
  # .ttf/.otf files. IDML-agnostic — works on any styled text.
  module TextEngine
    autoload :FontMetrics, "#{__dir__}/text_engine/font_metrics"
  end
end
