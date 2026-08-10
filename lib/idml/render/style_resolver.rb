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
      # itself stores only what the CSR declares.
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
      def self.extract_runs(story)
        return [] unless story&.inner

        story.inner.paragraph_style_range.flat_map do |psr|
          csr_runs(psr)
        end
      end

      # Returns the paragraph list for a story. Each paragraph groups
      # its runs and carries the paragraph-level attributes from the
      # owning PSR. Empty paragraphs (no runs after filtering) are
      # skipped.
      def self.extract_paragraphs(story, condition_filter: nil,
                                  style_lookup: nil)
        return [] unless story&.inner

        story.inner.paragraph_style_range.filter_map do |psr|
          next unless condition_visible?(psr, condition_filter)

          runs = csr_runs(psr, condition_filter: condition_filter,
                               style_lookup: style_lookup)
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
            rule_above_color: resolve_attr(style_lookup, psr, :stroke_color),
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
            rule_below_color: resolve_attr(style_lookup, psr, :stroke_color),
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
          )
          prepend_list_marker(paragraph)
          paragraph
        end
      end

      def self.csr_runs(psr, condition_filter: nil, style_lookup: nil)
        psr.character_style_range.filter_map do |csr|
          next unless condition_visible?(csr, condition_filter)

          text = csr.text_content
          next if text.nil? || text.empty?

          StyledRun.new(
            text: text,
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
          )
        end
      end
      private_class_method :csr_runs

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

      # Prepends the list marker (bullet glyph or numbered expression)
      # to the paragraph's first run when the paragraph is part of
      # a list. Mutates the first run's text in place.
      def self.prepend_list_marker(paragraph)
        marker = ListMarker.marker_for(paragraph)
        return unless marker
        return if paragraph.runs.empty?

        first_run = paragraph.runs.first
        first_run.text = "#{marker}#{first_run.text}"
      end
      private_class_method :prepend_list_marker

      # Concatenate runs into a single block. Used when the renderer
      # can't handle per-run styling (e.g., no font metrics available).
      def self.concatenate(runs)
        runs.map(&:text).join
      end
    end
  end
end
