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
      def self.extract_paragraphs(story, condition_filter: nil)
        return [] unless story&.inner

        story.inner.paragraph_style_range.filter_map do |psr|
          next unless condition_visible?(psr, condition_filter)

          runs = csr_runs(psr, condition_filter: condition_filter)
          next if runs.empty?

          Paragraph.new(
            runs: runs,
            alignment: runs.first.alignment,
            space_before: psr.space_before,
            space_after: psr.space_after,
            first_line_indent: psr.first_line_indent,
            left_indent: psr.left_indent,
            right_indent: psr.right_indent,
            auto_leading: psr.auto_leading,
            drop_cap_lines: psr.drop_cap_lines,
            drop_cap_characters: psr.drop_cap_characters,
            rule_above: psr.rule_above,
            rule_above_line_weight: psr.rule_above_line_weight,
            rule_above_color: psr.stroke_color,
            rule_above_tint: psr.rule_above_tint,
            rule_above_offset: psr.rule_above_offset,
            rule_above_left_indent: psr.rule_above_left_indent,
            rule_above_right_indent: psr.rule_above_right_indent,
            rule_above_width: psr.rule_above_width,
            rule_below: psr.rule_below,
            rule_below_line_weight: psr.rule_below_line_weight,
            rule_below_color: psr.stroke_color,
            rule_below_tint: psr.rule_below_tint,
            rule_below_offset: psr.rule_below_offset,
            rule_below_left_indent: psr.rule_below_left_indent,
            rule_below_right_indent: psr.rule_below_right_indent,
            rule_below_width: psr.rule_below_width,
          )
        end
      end

      def self.csr_runs(psr, condition_filter: nil)
        psr.character_style_range.filter_map do |csr|
          next unless condition_visible?(csr, condition_filter)

          text = csr.text_content
          next if text.nil? || text.empty?

          StyledRun.new(
            text: text,
            font_style: csr.font_style,
            point_size: csr.point_size || DEFAULT_POINT_SIZE,
            fill_color: csr.fill_color,
            fill_tint: csr.fill_tint,
            applied_font: csr.applied_font,
            alignment: alignment_for(csr),
            tracking: csr.tracking,
            capitalization: csr.capitalization,
            position: csr.position,
            underline: csr.underline,
            underline_offset: csr.underline_offset,
            underline_weight: csr.underline_weight,
            strike_thru: csr.strike_thru,
            strike_through_offset: csr.strike_through_offset,
            strike_through_weight: csr.strike_through_weight,
            horizontal_scale: csr.horizontal_scale,
            vertical_scale: csr.vertical_scale,
            baseline_shift: csr.baseline_shift,
          )
        end
      end
      private_class_method :csr_runs

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

      # Concatenate runs into a single block. Used when the renderer
      # can't handle per-run styling (e.g., no font metrics available).
      def self.concatenate(runs)
        runs.map(&:text).join
      end
    end
  end
end
