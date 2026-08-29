# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # The no-metrics fallback path of TextFrameRenderer: when no
      # FontMetrics is available (no shaper → no wrap), all runs
      # emit as one `text_rich` block per frame and footnote text
      # stacks at the frame bottom. Chain threading is best-effort
      # here — the simple path doesn't wrap, so the first frame's
      # render typically emits all content and clears the chain
      # state.
      #
      # A class-methods module extended into TextFrameRenderer —
      # it shares the host's font resolution (MECE: this module
      # owns the rough path; the host owns the shaping engine).
      module SimpleText
        def simple_render(canvas, state, context, box)
          runs = collect_runs(state)
          return if runs.empty?

          runs_for = build_rich_runs(runs, context)
          first_size = runs.first.point_size ||
            TextFrameRenderer::DEFAULT_SIZE
          canvas.text_rich(
            runs_for,
            at: [box[:x], box[:y] + box[:height] - first_size],
          )
          emit_simple_footnotes(canvas, runs, context, box)
          state.paragraphs = []
          state.current_paragraph = nil
          state.runs_remaining = []
        end

        # Footnote text for the rough (no-metrics) path: one line
        # per footnote paragraph, stacked upward from the frame's
        # bottom edge below a hairline separator. Paragraphs are
        # already marker-prefixed at extraction.
        def emit_simple_footnotes(canvas, runs, context, box)
          paragraphs = runs.flat_map(&:footnote_paragraphs).compact
          return if paragraphs.empty?

          size = paragraphs.first.runs.first&.point_size ||
            TextFrameRenderer::DEFAULT_SIZE
          block_top = box[:y] + (paragraphs.length * size)
          canvas.line_width = 0.5
          canvas.stroke_color([:gray, 0.0])
          canvas.move_to(box[:x], block_top + (size * 0.3))
          canvas.line_to(box[:x] + (box[:width] * 0.25),
                         block_top + (size * 0.3))
          canvas.stroke

          paragraphs.reverse_each.with_index do |paragraph, index|
            canvas.text_rich(
              build_rich_runs(paragraph.runs, context),
              at: [box[:x], box[:y] + ((index + 1) * size)],
            )
          end
        end

        def collect_runs(state)
          runs = state.runs_remaining || []
          if state.current_paragraph
            runs + state.current_paragraph.runs
          else
            runs + state.paragraphs.flat_map(&:runs)
          end
        end

        def build_rich_runs(runs, context)
          runs.map do |run|
            {
              text: run.text,
              font: font_for_run(run, context),
              size: run.point_size || TextFrameRenderer::DEFAULT_SIZE,
            }
          end
        end
      end
    end
  end
end
