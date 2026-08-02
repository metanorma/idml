# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Group by iterating its child page items and
      # delegating each to the appropriate renderer via
      # PageItemRenderer. Applies the Group's ItemTransform via `cm`.
      class GroupRenderer
        def self.render(context)
          group = context.item
          ops = []

          ops << Render::Path.save_state
          group.rectangle.each do |rect|
            ops << render_child(rect, context)
          end
          group.text_frame.each do |tf|
            ops << render_child(tf, context)
          end
          group.polygon.each do |poly|
            ops << render_child(poly, context)
          end
          ops << Render::Path.restore_state

          ops.compact.join("\n")
        end

        def self.render_child(child, context)
          child_context = Render::RenderContext.new(
            item: child,
            package: context.package,
            font_resolver: context.font_resolver,
            color_resolver: context.color_resolver,
            font_ps_name: context.font_ps_name,
            page_width: context.page_width,
            page_height: context.page_height,
          )
          PageItemRenderer.render(child_context)
        end
        private_class_method :render_child
      end
    end
  end
end
