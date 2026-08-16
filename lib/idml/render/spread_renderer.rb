# frozen_string_literal: true

module Idml
  module Render
    # Renders a typed `Parts::Spread` onto a Pdfrb::Content::Canvas.
    class SpreadRenderer
      def initialize(font_metrics: nil, font_ps_name: Render::DEFAULT_FONT,
                     package: nil, layer_filter: LayerFilter::EXCLUDE_NONE,
                     font_ref_resolver: nil, structure: nil,
                     position_tracker: nil, font_map: {},
                     condition_filter: nil, style_lookup: nil)
        @font_metrics = font_metrics
        @font_ps_name = font_ps_name
        @package = package
        @layer_filter = layer_filter
        @font_ref_resolver = font_ref_resolver
        @structure = structure
        @position_tracker = position_tracker
        @font_map = font_map
        @condition_filter = condition_filter
        @style_lookup = style_lookup
      end

      def render(canvas, spread, page_width:, page_height:, image_refs: [],
                 page_index: 0)
        context_base = {
          package: @package,
          font_metrics: @font_metrics,
          font_ref_resolver: @font_ref_resolver,
          color_resolver: build_color_resolver,
          font_ps_name: @font_ps_name,
          font_map: @font_map,
          page_width: page_width,
          page_height: page_height,
          layer_filter: @layer_filter,
          structure: @structure,
          page_index: page_index,
          position_tracker: @position_tracker,
          chain_controller: StoryChainController.new,
          condition_filter: @condition_filter,
          style_lookup: @style_lookup,
          text_wrap_resolver: build_text_wrap_resolver(spread, page_height),
        }
        images_by_parent = group_images_by_parent(image_refs)

        canvas.save_graphics_state do
          render_background(canvas, page_width, page_height)
          render_master_items(canvas, spread, context_base, images_by_parent)
          spread.each_page_item do |item|
            next unless @layer_filter.visible?(item)

            render_item_images(canvas, images_by_parent, item.self_attr)
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

      # Groups image refs by their parent page item's Self so each
      # item's images render when that item is reached in z-order
      # (instead of all upfront as a background layer).
      def group_images_by_parent(image_refs)
        image_refs.each_with_object({}) do |ref, hash|
          parent = ref[:parent_self]
          next unless parent

          (hash[parent] ||= []) << ref
        end
      end

      def render_item_images(canvas, images_by_parent, item_self)
        refs = images_by_parent[item_self]
        return unless refs

        render_images(canvas, refs)
      end

      def render_images(canvas, image_refs)
        return if image_refs.empty?

        image_refs.each do |ref|
          placement = ref[:placement]
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

      def render_master_items(canvas, spread, context_base, images_by_parent)
        return unless @package

        resolve_master_spreads(spread).each do |master|
          render_master_page_items(canvas, master, context_base,
                                   images_by_parent)
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

      def render_master_page_items(canvas, master_part, context_base,
                                   images_by_parent)
        master_part.master_spread.each do |master_so|
          master_so.each_page_item do |item|
            next unless @layer_filter.visible?(item)

            render_item_images(canvas, images_by_parent, item.self_attr)
            context = RenderContext.new(context_base.merge(item: item))
            PageItemRenderer.render(canvas, context)
          end
        end
      end

      def build_color_resolver
        return nil unless @package&.graphic

        ColorResolver.new(@package.graphic)
      end

      def build_text_wrap_resolver(spread, page_height)
        TextWrapResolver.build(spread, page_height: page_height)
      end
    end
  end
end
