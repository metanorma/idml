# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      class GroupRenderer
        def self.render(canvas, context)
          group = context.item
          canvas.save_graphics_state do
            apply_transform(canvas, group.item_transform)
            group.each_page_item do |child|
              next unless context.layer_filter&.visible?(child)

              child_context = Render::RenderContext.new(
                item: child,
                package: context.package,
                font_metrics: context.font_metrics,
                font_ref_resolver: context.font_ref_resolver,
                color_resolver: context.color_resolver,
                font_ps_name: context.font_ps_name,
                page_width: context.page_width,
                page_height: context.page_height,
                layer_filter: context.layer_filter,
                structure: context.structure,
                page_index: context.page_index,
              )
              PageItemRenderer.render(canvas, child_context)
            end
          end
        end

        def self.apply_transform(canvas, item_transform)
          return unless item_transform

          t = Geometry.parse_transform(item_transform)
          return unless t

          canvas.concat(t.a, t.b, t.c, t.d, t.e, t.f)
        end
        private_class_method :apply_transform
      end
    end
  end
end
