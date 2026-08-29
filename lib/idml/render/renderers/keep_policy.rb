# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Paragraph deferral policy (keep options + forced breaks):
      # decides whether a paragraph moves wholly to the next
      # frame/column instead of being split. Honors StartParagraph
      # forced breaks, KeepAllLinesTogether, the KeepFirstLines /
      # KeepLastLines partial windows (measured-line-count
      # approximation), and KeepWithNext. Pure predicates over the
      # paragraph chain state and frame geometry — no canvas, no
      # emission (MECE: TextFrameRenderer owns flow and emission;
      # FrameMetrics owns frame positioning).
      module KeepPolicy
        BREAK_MODES = %w[
          NextPage NextColumn NextFrame NextOddPage NextEvenPage
        ].freeze

        module_function

        # True when the paragraph should move wholly to the next
        # frame: a StartParagraph forced break, or a keep rule that
        # the remaining space violates (never for the frame's
        # first paragraph, so progress is always made).
        def paragraph_deferred?(paragraph, next_paragraph,
                                layout_frame, font, cursor_y,
                                bottom_limit, placed_any)
          return true if paragraph_break?(paragraph) && placed_any
          return false unless placed_any
          return true if keep_with_next_break?(paragraph, next_paragraph,
                                               layout_frame, font,
                                               cursor_y, bottom_limit)

          keep_all_lines_break?(paragraph, layout_frame, font,
                                cursor_y, bottom_limit) ||
            keep_windows_break?(paragraph, layout_frame, font,
                                cursor_y, bottom_limit)
        end

        # KeepAllLinesTogether: defer when the paragraph cannot
        # fully fit the remaining space.
        def keep_all_lines_break?(paragraph, layout_frame, font,
                                  cursor_y, bottom_limit)
          return false unless paragraph.keep_all_lines_together

          height = paragraph_block_height(paragraph, layout_frame, font)
          (cursor_y - height) < bottom_limit
        end

        # Partial keep windows, approximated by measured line
        # counts: KeepFirstLines defers when fewer than N lines
        # fit; KeepLastLines defers when the overflow tail for the
        # next frame would strand fewer than N lines.
        def keep_windows_break?(paragraph, layout_frame, font,
                                cursor_y, bottom_limit)
          return false unless paragraph.keep_first_lines ||
            paragraph.keep_last_lines

          height = paragraph_block_height(paragraph, layout_frame, font)
          return false if (cursor_y - height) >= bottom_limit

          leading = FrameMetrics.leading_for(paragraph)
          lines_fit = [((cursor_y - bottom_limit) / leading).floor, 0].max
          first_window_break?(paragraph, lines_fit) ||
            last_window_break?(paragraph, lines_fit, height, leading)
        end

        def first_window_break?(paragraph, lines_fit)
          paragraph.keep_first_lines &&
            lines_fit < paragraph.keep_first_lines
        end

        def last_window_break?(paragraph, lines_fit, height, leading)
          return false unless paragraph.keep_last_lines

          total_lines = [(height / leading).ceil, 1].max
          lines_fit.positive? &&
            (total_lines - lines_fit) < paragraph.keep_last_lines
        end

        # KeepWithNext: this paragraph defers when the next
        # paragraph is forced to the next frame, or when the next
        # paragraph's first line would not fit after this one.
        def keep_with_next_break?(paragraph, next_paragraph,
                                  layout_frame, font, cursor_y,
                                  bottom_limit)
          return false unless keepable_pair?(paragraph, next_paragraph)
          return true if paragraph_break?(next_paragraph)

          height = paragraph_block_height(paragraph, layout_frame, font)
          (cursor_y - height - FrameMetrics.leading_for(next_paragraph)) <
            bottom_limit
        end

        def keepable_pair?(paragraph, next_paragraph)
          !paragraph.keep_with_next.nil? && !next_paragraph.nil?
        end

        # True when the paragraph requests a forced break to the
        # next frame/column (StartParagraph). All break flavors act
        # at frame/column granularity.
        def paragraph_break?(paragraph)
          BREAK_MODES.include?(paragraph.start_paragraph)
        end

        def paragraph_block_height(paragraph, layout_frame, font)
          wrap_width = TextEngine::VerticalLayout.wrap_width(
            layout_frame, paragraph.right_indent || 0
          )
          TextEngine::Measurement.paragraph_height(
            paragraph, font, wrap_width
          )
        end
      end
    end
  end
end
