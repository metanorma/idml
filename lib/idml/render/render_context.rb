# frozen_string_literal: true

module Idml
  module Render
    # Shared state passed to every page-item renderer. Carries the
    # package (for story/color lookups), font/color resolvers, the
    # current font's PostScript name, and page dimensions. Renderers
    # are pure functions of this context + the page item.
    RenderContext = Struct.new(
      :item,
      :package,
      :font_resolver,
      :color_resolver,
      :font_ps_name,
      :page_width,
      :page_height,
      :layer_filter,
      keyword_init: true,
    )
  end
end
