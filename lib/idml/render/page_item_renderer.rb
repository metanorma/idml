# frozen_string_literal: true

module Idml
  module Render
    # Registry-based dispatch for page-item rendering. Maps element
    # classes to renderer classes. Adding a new page-item type = adding
    # a new entry to RENDERER_MAP + creating the renderer class.
    # Renderers are loaded lazily via autoload (no eager require).
    module PageItemRenderer
      RENDERER_MAP = {
        Idml::Elements::Rectangle => "RectangleRenderer",
        Idml::Elements::TextFrame => "TextFrameRenderer",
        Idml::Elements::Polygon => "PolygonRenderer",
        Idml::Elements::GraphicLine => "GraphicLineRenderer",
        Idml::Elements::Group => "GroupRenderer",
        Idml::Elements::Table => "TableRenderer",
      }.freeze

      def self.render(canvas, context)
        renderer = renderer_for(context.item)
        return nil unless renderer

        renderer.render(canvas, context)
      end

      def self.renderer_for(item)
        renderer_name = RENDERER_MAP[item.class]
        return nil unless renderer_name

        Render::Renderers.const_get(renderer_name)
      end
    end
  end
end
