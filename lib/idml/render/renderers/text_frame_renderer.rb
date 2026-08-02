# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      class TextFrameRenderer
        DEFAULT_SIZE = 12.0

        def self.render(canvas, context)
          frame = context.item
          return unless frame.parent_story
          return unless chain_head?(frame)

          story = context.package&.story_by_id(frame.parent_story)
          return unless story

          runs = StyleResolver.extract_runs(story)
          return if runs.empty?

          box = frame_box(frame, context.page_height)
          render_runs(canvas, runs, context, box)
        end

        def self.chain_head?(frame)
          frame.previous_text_frame.nil? || frame.previous_text_frame == "n"
        end
        private_class_method :chain_head?

        def self.frame_box(frame, page_height)
          bounds = frame.geometric_bounds
          return { x: 72.0, y: page_height - 72.0, width: 400.0,
                   height: 600.0 } unless bounds

          transform = Geometry.parse_transform(frame.item_transform)
          transformed = Geometry.transform_bounds(bounds, transform)
          Geometry.bounds_to_pdf_rect(transformed, page_height)
        end
        private_class_method :frame_box

        def self.render_runs(canvas, runs, context, box)
          runs.each_with_index do |run, index|
            y = box[:y] + box[:height] - (index + 1) * run.point_size * 1.2
            canvas.text(run.text, at: [box[:x], y],
                                   font: context.font_ps_name,
                                   size: run.point_size)
          end
        end
        private_class_method :render_runs
      end
    end
  end
end