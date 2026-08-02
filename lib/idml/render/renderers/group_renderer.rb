# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Group by applying the Group's ItemTransform via
      # the `cm` operator, then iterating child page items and delegating
      # each to the appropriate renderer via PageItemRenderer.
      class GroupRenderer
        def self.render(context)
          group = context.item
          ops = []
          ops << Render::Path.save_state
          ops << transform_op(group.item_transform)
          ops << render_children(group, context)
          ops << Render::Path.restore_state
          ops.compact.join("\n")
        end

        def self.transform_op(item_transform)
          return nil unless item_transform

          t = Geometry.parse_transform(item_transform)
          return nil unless t

          Render::Path.transform(a: t.a, b: t.b, c: t.c,
                                 d: t.d, e: t.e, f: t.f)
        end

        def self.render_children(group, context)
          child_ops = []
          group.each_page_item do |child|
            next unless context.layer_filter&.visible?(child)

            child_ops << render_child(child, context)
          end
          child_ops.compact.join("\n")
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
