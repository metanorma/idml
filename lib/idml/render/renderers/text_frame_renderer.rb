# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame by resolving its ParentStory to a
      # Parts::Story, extracting styled runs via StyleResolver, and
      # emitting PDF text operators. Each styled run becomes its own
      # BT...ET block with per-run font, size, and color.
      class TextFrameRenderer
        DEFAULT_SIZE = 12.0
        MAX_TEXT = 1000
        DEFAULT_FRAME_WIDTH = 400.0

        def self.render(context)
          frame = context.item
          return nil unless frame.parent_story
          return nil unless chain_head?(frame)

          story = context.package&.story_by_id(frame.parent_story)
          return nil unless story

          runs = StyleResolver.extract_runs(story)
          return nil if runs.empty?

          box = frame_box(frame, context.page_height)
          emit_runs(runs, context, box)
        end

        def self.chain_head?(frame)
          frame.previous_text_frame.nil? || frame.previous_text_frame == "n"
        end
        private_class_method :chain_head?

        def self.frame_box(frame, page_height)
          bounds = frame.geometric_bounds
          return default_box(page_height) unless bounds

          transform = Geometry.parse_transform(frame.item_transform)
          transformed = Geometry.transform_bounds(bounds, transform)
          box = Geometry.bounds_to_pdf_rect(transformed, page_height)
          apply_insets(box, frame)
        end

        def self.default_box(page_height)
          { x: 72.0, y: page_height - 72.0,
            width: DEFAULT_FRAME_WIDTH, height: 600.0 }
        end

        def self.apply_insets(box, frame)
          pref = frame.text_frame_preference&.first
          return box unless pref

          insets = inset_values(pref)
          {
            x: box[:x] + insets[:left],
            y: box[:y] + insets[:bottom],
            width: [box[:width] - insets[:left] - insets[:right], 1].max,
            height: [box[:height] - insets[:top] - insets[:bottom], 1].max,
          }
        end
        private_class_method :apply_insets

        def self.inset_values(pref)
          {
            top: pref.inset_top || 0,
            bottom: pref.inset_bottom || 0,
            left: pref.inset_left || 0,
            right: pref.inset_right || 0,
          }
        end
        private_class_method :inset_values

        def self.emit_runs(runs, context, box)
          font = resolve_font(context)
          return simple_text(runs, context, box) unless font

          per_run_shaped_text(runs, context, box, font)
        end
        private_class_method :emit_runs

        def self.resolve_font(context)
          return nil unless context.font_resolver

          context.font_resolver.resolve(
            family_name: Render::DEFAULT_FONT, style_name: "Regular",
          )
        end
        private_class_method :resolve_font

        def self.simple_text(runs, context, box)
          text = StyleResolver.concatenate(runs)
          Render::Text.show_run(
            text_string: Render::Text.escape(text.slice(0, MAX_TEXT)),
            font_name: context.font_ps_name,
            size: runs.first.point_size,
            x: box[:x],
            y: box[:y] + box[:height] - runs.first.point_size,
          )
        end
        private_class_method :simple_text

        def self.per_run_shaped_text(runs, context, box, font)
          ops = []
          runs.each_with_index do |run, i|
            ops << render_run(run, context, box, font, i)
          end
          ops.compact.join("\n")
        end
        private_class_method :per_run_shaped_text

        def self.render_run(run, context, box, font, _run_index)
          font_ps = resolve_run_font(run, context)
          glyphs = TextEngine::Shaper.shape(
            text: run.text, font: font, size: run.point_size,
          )
          lines = TextEngine::LineBreaker.break(
            glyphs: glyphs, frame_width: box[:width],
          )
          lines.each do |line|
            TextEngine::Justifier.justify(line: line, frame_width: box[:width])
          end
          run_frame = TextEngine::VerticalLayout::Frame.new(
            box[:x], box[:y], box[:width], box[:height], 0, 0, 0, 0
          )
          positioned = TextEngine::VerticalLayout.layout(
            lines: lines, frame: run_frame, font_size: run.point_size,
            leading: run.point_size * 1.2
          )
          return nil if positioned.empty?

          run_operators(positioned, font_ps, run, context)
        end
        private_class_method :render_run

        def self.resolve_run_font(run, context)
          return context.font_ps_name unless run.applied_font

          ps = context.font_ref_resolver&.resolve(run.applied_font)
          ps || context.font_ps_name
        end
        private_class_method :resolve_run_font

        def self.run_operators(positioned, font_ps, run, context)
          color = run_color_op(run, context)
          [
            "BT",
            "/#{font_ps} #{run.point_size} Tf",
            color,
            Render::Text.show_positioned(positioned),
            "ET",
          ].compact.join("\n")
        end
        private_class_method :run_operators

        def self.run_color_op(run, context)
          return nil unless run.fill_color
          return nil if run.fill_color == "Color/None"

          color = context.color_resolver&.resolve(run.fill_color)
          return nil unless color

          Render::Color.fill_op(color)
        end
        private_class_method :run_color_op
      end
    end
  end
end
