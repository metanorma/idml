# frozen_string_literal: true

module Idml
  module Render
    # Extracts styled text from an IDML Story in two granularities:
    #
    # 1. `extract_runs` — flat list of `StyledRun` (character-level
    #    attributes only). Useful when paragraph boundaries don't
    #    matter (e.g., simple-render fallback).
    # 2. `extract_paragraphs` — list of `Paragraph` structs, each
    #    carrying paragraph-level attributes (spacing, indents,
    #    leading) plus its runs. Used by the layout engine so the
    #    renderer can apply SpaceBefore / FirstLineIndent / etc.
    #
    # Both methods read the same source (PSR → CSR → Content) so the
    # text content is identical; only the grouping and attribute
    # propagation differ.
    class StyleResolver
      # Character-level attributes carried per run. Defaults are
      # applied at render time (e.g., DEFAULT_POINT_SIZE) — the Struct
      # itself stores only what the CSR declares. `footnote_number`
      # and `footnote_paragraphs` are set only on synthesized
      # footnote-marker runs (see Render::Footnote).
      StyledRun = Struct.new(
        :text,
        :font_style,
        :point_size,
        :fill_color,
        :fill_tint,
        :applied_font,
        :alignment,
        :tracking,
        :capitalization,
        :position,
        :underline,
        :underline_offset,
        :underline_weight,
        :strike_thru,
        :strike_through_offset,
        :strike_through_weight,
        :horizontal_scale,
        :vertical_scale,
        :baseline_shift,
        :footnote_number,
        :footnote_paragraphs,
        # Ruby (phonetic annotation) — from the CSR's Ruby*
        # attributes. Present only on runs with a RubyString.
        :ruby_string,
        :ruby_font_size,
        :ruby_position,
        :tatechuyoko,
        keyword_init: true,
      )

      # Paragraph-level attributes carried alongside a run list.
      # Each attribute comes from the owning PSR and is nil when the
      # PSR doesn't declare it.
      Paragraph = Struct.new(
        :runs,
        :alignment,
        :space_before,
        :space_after,
        :first_line_indent,
        :left_indent,
        :right_indent,
        :auto_leading,
        :drop_cap_lines,
        # Justification distribution caps (percent; from PSR).
        :maximum_word_spacing,
        :maximum_letter_spacing,
        # Forced paragraph break (StartParagraph: NextPage /
        # NextColumn / NextFrame / NextOddPage / NextEvenPage).
        :start_paragraph,
        # Widow/orphan control: KeepAllLinesTogether pushes the whole
        # paragraph to the next frame when it cannot fully fit.
        :keep_all_lines_together,
        :bullets_and_numbering_list_type,
        :bullet_character_value,
        :bullets_text_after,
        :numbering_expression,
        :drop_cap_characters,
        # RuleAbove / RuleBelow — paragraph rules (horizontal lines
        # above/below the paragraph block). Driven by PSR attributes.
        :rule_above,
        :rule_above_line_weight,
        :rule_above_color,
        :rule_above_tint,
        :rule_above_offset,
        :rule_above_left_indent,
        :rule_above_right_indent,
        :rule_above_width,
        :rule_below,
        :rule_below_line_weight,
        :rule_below_color,
        :rule_below_tint,
        :rule_below_offset,
        :rule_below_left_indent,
        :rule_below_right_indent,
        :rule_below_width,
        # ParagraphShading — fill rect behind the paragraph block.
        # Color comes from Properties > ParagraphShadingColor.
        :paragraph_shading_on,
        :paragraph_shading_color,
        :paragraph_shading_tint,
        :paragraph_shading_width,
        :paragraph_shading_left_offset,
        :paragraph_shading_right_offset,
        :paragraph_shading_top_offset,
        :paragraph_shading_bottom_offset,
        # ParagraphBorder — per-side strokes around the paragraph.
        :paragraph_border_on,
        :paragraph_border_color,
        :paragraph_border_tint,
        :paragraph_border_top_line_weight,
        :paragraph_border_left_line_weight,
        :paragraph_border_right_line_weight,
        :paragraph_border_bottom_line_weight,
        :paragraph_border_top_offset,
        :paragraph_border_left_offset,
        :paragraph_border_right_offset,
        :paragraph_border_bottom_offset,
        keyword_init: true,
      )

      DEFAULT_POINT_SIZE = 12.0

      # IDML `Justification` enum → Justifier symbol. Full justify
      # and binding-side variants defer to :left for now (TODO 80).
      ALIGNMENT_MAP = {
        "Left" => :left,
        "Center" => :center,
        "Right" => :right,
        "LeftJustified" => :left,
        "RightJustified" => :right,
        "CenterJustified" => :center,
        "FullyJustified" => :justified,
        "ToBinding" => :left,
      }.freeze

      # Returns the flat run list for a story. Each run carries only
      # character-level attributes. Paragraph boundaries are lost.
      # Footnote markers number sequentially across the story.
      def self.extract_runs(story)
        return [] unless story&.inner

        counter = Footnote.counter_for(nil)
        endnotes = Footnote.counter_for(nil)
        story.inner.paragraph_style_range.flat_map do |psr|
          csr_runs(psr, footnote_counter: counter, endnote_counter: endnotes)
        end
      end

      # Returns the paragraph list for a story. Each paragraph groups
      # its runs and carries the paragraph-level attributes from the
      # owning PSR. Empty paragraphs (no runs after filtering) are
      # skipped. Footnotes anchored in the story emit superscript
      # marker runs, numbered sequentially from the FootnoteOption's
      # StartAt (default 1).
      def self.extract_paragraphs(story, condition_filter: nil,
                                  style_lookup: nil, footnote_option: nil)
        return [] unless story&.inner

        extract_container_paragraphs(
          story.inner,
          condition_filter: condition_filter, style_lookup: style_lookup,
          footnote_option: footnote_option
        )
      end

      # Extracts paragraphs from any container exposing
      # `paragraph_style_range` (StoryInner, Elements::Footnote).
      # Footnote-counter state is shared across the whole walk so
      # footnotes number in document order.
      def self.extract_container_paragraphs(container, condition_filter: nil,
                                            style_lookup: nil,
                                            footnote_option: nil)
        counter = Footnote.counter_for(footnote_option)
        endnotes = Footnote.counter_for(nil)
        container.paragraph_style_range.filter_map do |psr|
          next unless condition_visible?(psr, condition_filter)

          runs = csr_runs(psr, condition_filter: condition_filter,
                               style_lookup: style_lookup,
                               footnote_counter: counter,
                               footnote_option: footnote_option,
                               endnote_counter: endnotes)
          next if runs.empty?

          paragraph = Paragraph.new(
            runs: runs,
            alignment: runs.first.alignment,
            space_before: resolve_attr(style_lookup, psr, :space_before),
            space_after: resolve_attr(style_lookup, psr, :space_after),
            first_line_indent: resolve_attr(style_lookup, psr,
                                            :first_line_indent),
            left_indent: resolve_attr(style_lookup, psr, :left_indent),
            right_indent: resolve_attr(style_lookup, psr, :right_indent),
            auto_leading: resolve_attr(style_lookup, psr, :auto_leading),
            maximum_word_spacing: resolve_attr(
              style_lookup, psr, :maximum_word_spacing
            ),
            maximum_letter_spacing: resolve_attr(
              style_lookup, psr, :maximum_letter_spacing
            ),
            start_paragraph: resolve_attr(style_lookup, psr,
                                          :start_paragraph),
            keep_all_lines_together: resolve_attr(
              style_lookup, psr, :keep_all_lines_together
            ),
            drop_cap_lines: resolve_attr(style_lookup, psr, :drop_cap_lines),
            drop_cap_characters: resolve_attr(style_lookup, psr,
                                              :drop_cap_characters),
            bullets_and_numbering_list_type: resolve_attr(
              style_lookup, psr, :bullets_and_numbering_list_type
            ),
            bullet_character_value: resolve_attr(style_lookup, psr,
                                                 :bullet_character_value),
            bullets_text_after: resolve_attr(style_lookup, psr,
                                             :bullets_text_after),
            numbering_expression: resolve_attr(style_lookup, psr,
                                               :numbering_expression),
            rule_above: resolve_attr(style_lookup, psr, :rule_above),
            rule_above_line_weight: resolve_attr(style_lookup, psr,
                                                 :rule_above_line_weight),
            rule_above_color: properties_color(psr, :rule_above_color) ||
                             resolve_attr(style_lookup, psr, :stroke_color),
            rule_above_tint: resolve_attr(style_lookup, psr,
                                          :rule_above_tint),
            rule_above_offset: resolve_attr(style_lookup, psr,
                                            :rule_above_offset),
            rule_above_left_indent: resolve_attr(style_lookup, psr,
                                                 :rule_above_left_indent),
            rule_above_right_indent: resolve_attr(style_lookup, psr,
                                                  :rule_above_right_indent),
            rule_above_width: resolve_attr(style_lookup, psr,
                                           :rule_above_width),
            rule_below: resolve_attr(style_lookup, psr, :rule_below),
            rule_below_line_weight: resolve_attr(style_lookup, psr,
                                                 :rule_below_line_weight),
            rule_below_color: properties_color(psr, :rule_below_color) ||
                             resolve_attr(style_lookup, psr, :stroke_color),
            rule_below_tint: resolve_attr(style_lookup, psr,
                                          :rule_below_tint),
            rule_below_offset: resolve_attr(style_lookup, psr,
                                            :rule_below_offset),
            rule_below_left_indent: resolve_attr(style_lookup, psr,
                                                 :rule_below_left_indent),
            rule_below_right_indent: resolve_attr(style_lookup, psr,
                                                  :rule_below_right_indent),
            rule_below_width: resolve_attr(style_lookup, psr,
                                           :rule_below_width),
            paragraph_shading_on: resolve_attr(style_lookup, psr,
                                               :paragraph_shading_on),
            paragraph_shading_color: properties_color(psr,
                                                      :paragraph_shading_color),
            paragraph_shading_tint: resolve_attr(style_lookup, psr,
                                                 :paragraph_shading_tint),
            paragraph_shading_width: resolve_attr(style_lookup, psr,
                                                  :paragraph_shading_width),
            paragraph_shading_left_offset: resolve_attr(
              style_lookup, psr, :paragraph_shading_left_offset
            ),
            paragraph_shading_right_offset: resolve_attr(
              style_lookup, psr, :paragraph_shading_right_offset
            ),
            paragraph_shading_top_offset: resolve_attr(
              style_lookup, psr, :paragraph_shading_top_offset
            ),
            paragraph_shading_bottom_offset: resolve_attr(
              style_lookup, psr, :paragraph_shading_bottom_offset
            ),
            paragraph_border_on: resolve_attr(style_lookup, psr,
                                              :paragraph_border_on),
            paragraph_border_color: properties_color(psr,
                                                     :paragraph_border_color),
            paragraph_border_tint: resolve_attr(style_lookup, psr,
                                                :paragraph_border_tint),
            paragraph_border_top_line_weight: resolve_attr(
              style_lookup, psr, :paragraph_border_top_line_weight
            ),
            paragraph_border_left_line_weight: resolve_attr(
              style_lookup, psr, :paragraph_border_left_line_weight
            ),
            paragraph_border_right_line_weight: resolve_attr(
              style_lookup, psr, :paragraph_border_right_line_weight
            ),
            paragraph_border_bottom_line_weight: resolve_attr(
              style_lookup, psr, :paragraph_border_bottom_line_weight
            ),
            paragraph_border_top_offset: resolve_attr(
              style_lookup, psr, :paragraph_border_top_offset
            ),
            paragraph_border_left_offset: resolve_attr(
              style_lookup, psr, :paragraph_border_left_offset
            ),
            paragraph_border_right_offset: resolve_attr(
              style_lookup, psr, :paragraph_border_right_offset
            ),
            paragraph_border_bottom_offset: resolve_attr(
              style_lookup, psr, :paragraph_border_bottom_offset
            ),
          )
          prepend_list_marker(paragraph)
          paragraph
        end
      end

      # Reads a color value element from the PSR's Properties (e.g.
      # Properties > ParagraphShadingColor). Returns the color name
      # string, or nil when the element is absent.
      def self.properties_color(psr, element_attr)
        psr.properties.first&.public_send(element_attr)&.value
      end
      private_class_method :properties_color

      def self.csr_runs(psr, condition_filter: nil, style_lookup: nil,
                        footnote_counter: nil, footnote_option: nil,
                        endnote_counter: nil)
        counter = footnote_counter || Footnote.counter_for(footnote_option)
        endnotes = endnote_counter || Footnote.counter_for(nil)
        psr.character_style_range.flat_map do |csr|
          next [] unless condition_visible?(csr, condition_filter)

          csr_content_runs(csr, condition_filter: condition_filter,
                                style_lookup: style_lookup,
                                footnote_counter: counter,
                                footnote_option: footnote_option,
                                endnote_counter: endnotes)
        end
      end

      # Builds the runs for one CSR: its text run (when non-empty)
      # plus one superscript marker run per anchored Footnote. A CSR
      # holding only a footnote still emits its marker.
      def self.csr_content_runs(csr, condition_filter:, style_lookup:,
                                footnote_counter:, footnote_option:,
                                endnote_counter:)
        text = csr.text_content
        runs = []
        unless text.nil? || text.empty?
          runs << text_run(csr, style_lookup: style_lookup)
        end
        csr.footnote.each do |element|
          number = footnote_counter.next_number
          paragraphs = Footnote.extract(
            element, number, condition_filter: condition_filter,
                             style_lookup: style_lookup,
                             option: footnote_option
          )
          runs << Footnote.marker_run(number, runs.last, paragraphs,
                                      footnote_option)
        end
        runs.concat(endnote_marker_runs(csr, endnote_counter, runs.last))
        runs
      end

      # Endnote reference markers (CSR > EndnoteRange): superscript,
      # numbered by a counter SEPARATE from footnotes. The endnote
      # text lives in another story (IsEndnoteStory) and is not yet
      # rendered — see TODO 117.
      def self.endnote_marker_runs(csr, endnote_counter, base_run)
        csr.endnote_range.map do |_range|
          Footnote.marker_run(endnote_counter.next_number, base_run,
                              nil, nil)
        end
      end
      private_class_method :endnote_marker_runs
      private_class_method :csr_content_runs

      def self.text_run(csr, style_lookup:)
        StyledRun.new(
          text: csr.text_content,
          font_style: resolve_csr(style_lookup, csr, :font_style),
          point_size: resolve_csr(style_lookup, csr, :point_size) ||
            DEFAULT_POINT_SIZE,
          fill_color: resolve_csr(style_lookup, csr, :fill_color),
          fill_tint: resolve_csr(style_lookup, csr, :fill_tint),
          applied_font: resolve_csr(style_lookup, csr, :applied_font),
          alignment: alignment_for(csr),
          tracking: resolve_csr(style_lookup, csr, :tracking),
          capitalization: resolve_csr(style_lookup, csr, :capitalization),
          position: resolve_csr(style_lookup, csr, :position),
          underline: resolve_csr(style_lookup, csr, :underline),
          underline_offset: resolve_csr(style_lookup, csr,
                                        :underline_offset),
          underline_weight: resolve_csr(style_lookup, csr,
                                        :underline_weight),
          strike_thru: resolve_csr(style_lookup, csr, :strike_thru),
          strike_through_offset: resolve_csr(style_lookup, csr,
                                             :strike_through_offset),
          strike_through_weight: resolve_csr(style_lookup, csr,
                                             :strike_through_weight),
          horizontal_scale: resolve_csr(style_lookup, csr,
                                        :horizontal_scale),
          vertical_scale: resolve_csr(style_lookup, csr, :vertical_scale),
          baseline_shift: resolve_csr(style_lookup, csr, :baseline_shift),
          ruby_string: resolve_csr(style_lookup, csr, :ruby_string),
          ruby_font_size: resolve_csr(style_lookup, csr, :ruby_font_size),
          ruby_position: resolve_csr(style_lookup, csr, :ruby_position),
          tatechuyoko: resolve_csr(style_lookup, csr, :tatechuyoko),
        )
      end
      private_class_method :text_run

      # Resolves a paragraph-level attribute from PSR or its
      # referenced ParagraphStyle. When style_lookup is nil,
      # falls back to reading the PSR directly (backward compat).
      def self.resolve_attr(style_lookup, psr, attr_name)
        return psr.public_send(attr_name) unless style_lookup

        style_lookup.resolve_para_attr(psr, attr_name)
      end
      private_class_method :resolve_attr

      # Resolves a character-level attribute from CSR or its
      # referenced CharacterStyle.
      def self.resolve_csr(style_lookup, csr, attr_name)
        return csr.public_send(attr_name) unless style_lookup

        style_lookup.resolve_char_attr(csr, attr_name)
      end
      private_class_method :resolve_csr

      # Drops the PSR/CSR when any of its AppliedConditions
      # references a hidden Condition. Returns true when no filter
      # is supplied (caller doesn't care about conditions).
      def self.condition_visible?(psr_or_csr, condition_filter)
        return true unless condition_filter

        condition_filter.visible?(psr_or_csr.applied_conditions)
      end
      private_class_method :condition_visible?

      def self.alignment_for(csr)
        ALIGNMENT_MAP[csr.justification] || :left
      end
      private_class_method :alignment_for

      HANGING_INDENT_WIDTH = 18.0

      # Prepends the list marker (bullet glyph or numbered expression)
      # to the paragraph's first run when the paragraph is part of
      # a list. Also applies a hanging indent so wrapped lines align
      # with the text after the marker, not with the marker itself.
      def self.prepend_list_marker(paragraph)
        marker = ListMarker.marker_for(paragraph)
        return unless marker
        return if paragraph.runs.empty?

        first_run = paragraph.runs.first
        first_run.text = "#{marker}#{first_run.text}"
        apply_hanging_indent(paragraph)
      end
      private_class_method :prepend_list_marker

      # Adjusts left_indent and first_line_indent for a hanging
      # indent effect: first line starts at the original left edge
      # (with the marker), wrapped lines indent by HANGING_INDENT_WIDTH.
      def self.apply_hanging_indent(paragraph)
        current_left = paragraph.left_indent || 0
        current_first = paragraph.first_line_indent || 0
        paragraph.left_indent = current_left + HANGING_INDENT_WIDTH
        paragraph.first_line_indent = current_first - HANGING_INDENT_WIDTH
      end
      private_class_method :apply_hanging_indent

      # Concatenate runs into a single block. Used when the renderer
      # can't handle per-run styling (e.g., no font metrics available).
      def self.concatenate(runs)
        runs.map(&:text).join
      end
    end
  end
end
