# frozen_string_literal: true

module Idml
  module Render
    # Renders a typed `Parts::Spread` into a PDF content stream.
    # Iterates over the SpreadObject's child page items and dispatches
    # each to the appropriate renderer via PageItemRenderer. All data
    # comes from typed lutaml-model instances — no raw XML parsing.
    # Master spread items are rendered first (background layer).
    # Items on hidden layers are skipped via LayerFilter.
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

      def render(spread, page_width:, page_height:, image_refs: [])
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

        ops = []
        ops << Path.save_state
        ops << render_background(page_width, page_height)
        ops << render_images(image_refs)
        ops << render_master_items(spread, context_base)
        spread.each_page_item do |item|
          next unless @layer_filter.visible?(item)

          context = RenderContext.new(context_base.merge(item: item))
          ops << PageItemRenderer.render(context)
        end
        ops << Path.restore_state
        ops.compact.join("\n")
      end

      private

      def render_master_items(spread, context_base)
        return "" unless @package

        master_ops = resolve_master_spreads(spread).map do |master|
          render_master_page_items(master, context_base)
        end
        master_ops.compact.join("\n")
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

      def render_master_page_items(master_part, context_base)
        master_part.master_spread.flat_map do |master_so|
          items = master_so.each_page_item.select do |item|
            @layer_filter.visible?(item)
          end
          items.map do |item|
            context = RenderContext.new(context_base.merge(item: item))
            PageItemRenderer.render(context)
          end
        end.compact.join("\n")
      end

      def render_background(width, height)
        [
          Color.white_fill,
          Path.rectangle(x: 0, y: 0, width: width, height: height),
          Path.fill,
        ].join("\n")
      end

      def render_images(image_refs)
        return "" if image_refs.empty?

        image_refs.map do |ref|
          placement = ref[:placement]
          Image.draw_image(
            name: ref[:name], x: placement[:x], y: placement[:y],
            scale_x: placement[:scale_x], scale_y: placement[:scale_y]
          )
        end.join("\n")
      end

      def build_color_resolver
        return nil unless @package&.graphic

        ColorResolver.new(@package.graphic)
      end
    end
  end
end
