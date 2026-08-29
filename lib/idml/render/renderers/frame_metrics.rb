# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Frame positioning policy for the text engine: where the
      # first baseline sits under each FirstBaselineOffset mode,
      # where the content block starts under vertical
      # justification, and how tall the pending content is
      # estimated to be. Pure functions of the TextFrame's
      # preference, the chain state, and font metrics — no canvas,
      # no emission (MECE: this module owns frame-positioning
      # policy; TextFrameRenderer owns flow and emission;
      # KeepPolicy owns paragraph deferral).
      module FrameMetrics
        FIRST_BASELINE_MODES = %w[
          AscentOffset FixedHeight CapHeight XHeight EmboxHeight
        ].freeze

        # pdfrb 0.7.1 never fills the cap_height metric, so
        # CapHeight / XHeight fall back to standard font
        # proportions (cap ≈ 0.72 em, x ≈ 0.52 em — Arial and
        # Helvetica both sit within 1% of these).
        CAP_HEIGHT_RATIO = 0.72
        X_HEIGHT_RATIO = 0.52

        module_function

        # Top y for the content block under the frame's vertical
        # justification: TopAlign keeps the frame top;
        # CenterAlign / BottomAlign offset by the slack between the
        # estimated content height and the available space
        # (JustifyAlign falls back to TopAlign behavior).
        def vertical_justify_top(top_y, bottom_limit, state, context)
          justification = text_frame_vertical_justification(context)
          return top_y unless %w[CenterAlign BottomAlign].include?(justification)

          available = top_y - bottom_limit
          slack = [available - estimate_content_height(state), 0].max
          return top_y if slack.zero?

          case justification
          when "CenterAlign" then top_y - (slack / 2)
          when "BottomAlign" then top_y - slack
          else top_y
          end
        end

        # FirstBaselineOffset: how far below the frame's top inset
        # the first line's baseline sits, relative to the layout's
        # leading-based default. AscentOffset shifts by (ascent −
        # leading), FixedHeight by (MinimumFirstBaselineOffset −
        # leading), CapHeight by the cap-height proportion, XHeight
        # by the x-height proportion, EmboxHeight by the em box
        # (the first paragraph's point size).
        def first_baseline_offset(context, state, font)
          pref = context.item&.text_frame_preference&.first
          mode = pref&.first_baseline_offset
          return 0.0 unless FIRST_BASELINE_MODES.include?(mode)

          baseline_target(pref, mode, state, font) -
            first_paragraph_leading(state)
        end

        # Distance from the top inset to the first baseline under
        # the given mode.
        def baseline_target(pref, mode, state, font)
          leading = first_paragraph_leading(state)
          case mode
          when "AscentOffset"
            ratio_scaled(font.ascent, font) * leading
          when "CapHeight"
            cap_ratio(font) * leading
          when "XHeight"
            X_HEIGHT_RATIO * leading
          when "EmboxHeight"
            first_paragraph_size(state)
          else
            pref.minimum_first_baseline_offset || leading
          end
        end

        def cap_ratio(font)
          cap = font.cap_height
          return CAP_HEIGHT_RATIO unless cap

          ratio_scaled(cap, font)
        end

        def ratio_scaled(metric, font)
          upem = font.units_per_em
          return 1.0 if upem.zero?

          metric / upem
        end

        def first_paragraph_size(state)
          paragraph = state.current_paragraph || state.paragraphs.first
          first_run = paragraph&.runs&.first
          first_run&.point_size || TextFrameRenderer::DEFAULT_SIZE
        end

        # Leading of a paragraph computed from its first run's
        # point size (the default size when it has no runs yet).
        def leading_for(paragraph)
          size = paragraph.runs.first&.point_size ||
            TextFrameRenderer::DEFAULT_SIZE
          TextEngine::VerticalLayout.leading_for(paragraph.auto_leading,
                                                 size)
        end

        def first_paragraph_leading(state)
          paragraph = state.current_paragraph || state.paragraphs.first
          unless paragraph
            return TextFrameRenderer::DEFAULT_SIZE *
                TextEngine::VerticalLayout::DEFAULT_LEADING_FACTOR
          end

          leading_for(paragraph)
        end

        def text_frame_vertical_justification(context)
          pref = context.item&.text_frame_preference&.first
          pref&.vertical_justification
        end

        # Estimates total renderable content height for vertical
        # justification. Walks paragraphs and runs, summing leading
        # per run plus paragraph space_before/after. Approximation:
        # treats each run as one line (wrap may produce more lines,
        # which would over-estimate slack; acceptable for
        # justification since we'd rather under-offset than
        # overflow).
        def estimate_content_height(state)
          paragraphs_for_estimate(state).sum { |p| paragraph_height(p) }
        end

        def paragraphs_for_estimate(state)
          result = []
          result << state.current_paragraph if state.current_paragraph
          result + state.paragraphs
        end

        def paragraph_height(paragraph)
          size = paragraph.runs.first&.point_size ||
            TextFrameRenderer::DEFAULT_SIZE
          leading = TextEngine::VerticalLayout.leading_for(
            paragraph.auto_leading, size
          )
          line_count = [paragraph.runs.length, 1].max
          (leading * line_count) + space_before_after(paragraph)
        end

        def space_before_after(paragraph)
          (paragraph.space_before || 0) + (paragraph.space_after || 0)
        end
      end
    end
  end
end
