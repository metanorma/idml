# frozen_string_literal: true

module Idml
  module Render
    # Renders a typed `Parts::Spread` onto a Pdfrb::Content::Canvas.
    class SpreadRenderer
      def initialize(font_resolver: nil, font_ps_name: Render::DEFAULT_FONT,
                     package: nil, layer_filter: LayerFilter::EXCLUDE_NONE,
                     font_ref_resolver: nil)
        @font_resolver = font_resolver
        @font_ps_name = font_ps_name
        @package = package
        @layer_filter = layer_filter
        @font_ref_resolver = font_ref_resolver
      end

      def render(canvas, spread, page_width:, page_height:, image_refs: [])
        context_base = {
          package: @package,
          font_resolver: @font_resolver,
          font_ref_resolver: @font_ref_resolver,
          color_resolver: build_color_resolver,
          font_ps_name: @font_ps_name,
          page_width: page_width,
          page_height: page_height,
          layer_filter: @layer_filter,
        }

        canvas.save_graphics_state do
          render_background(canvas, page_width, page_height)
          render_images(canvas, image_refs)
          render_master_items(canvas, spread, context_base)
          spread.each_page_item do |item|
            next unless @layer_filter.visible?(item)

            context = RenderContext.new(context_base.merge(item: item))
            PageItemRenderer.render(canvas, context)
          end
        end
      end

      private

      def render_background(canvas, width, height)
        canvas.fill_color([:gray, 1.0])
        canvas.rectangle(0, 0, width, height)
        canvas.fill
      end

      def render_images(canvas, image_refs)
        return if image_refs.empty?

        image_refs.each do |ref|
          placement = ref[:placement]
          placement[:scale_x].abs
          placement[:scale_y].abs
          canvas.save_graphics_state do
            apply_image_clip(canvas, ref)
            canvas.draw_image_matrix(ref[:name],
                                     a: placement[:scale_x], b: 0,
                                     c: 0, d: placement[:scale_y],
                                     e: placement[:x], f: placement[:y])
          end
        end
      end

      def apply_image_clip(canvas, ref)
        clip_box = ref[:clip_box]
        return unless clip_box

        canvas.rectangle(clip_box[:x], clip_box[:y],
                         clip_box[:width], clip_box[:height])
        canvas.clip
      end

      def render_master_items(canvas, spread, context_base)
        return unless @package

        resolve_master_spreads(spread).each do |master|
          render_master_page_items(canvas, master, context_base)
        end
      end

      def resolve_master_spreads(spread)
        masters = []
        spread.spread.flat_map(&:page).each do |page|
          next unless page.applied_master

          master = @package.master_spread_by_id(page.applied_master)
          masters << master if master && !masters.include?(master)
        end
        masters
      end

      def render_master_page_items(canvas, master_part, context_base)
        master_part.master_spread.each do |master_so|
          master_so.each_page_item do |item|
            next unless @layer_filter.visible?(item)

            context = RenderContext.new(context_base.merge(item: item))
            PageItemRenderer.render(canvas, context)
          end
        end
      end

      def build_color_resolver
        return nil unless @package&.graphic

        ColorResolver.new(@package.graphic)
      end
    end
  end
end
