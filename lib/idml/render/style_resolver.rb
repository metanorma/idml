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
        :strike_thru,
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
      def self.extract_paragraphs(story)
        return [] unless story&.inner

        story.inner.paragraph_style_range.filter_map do |psr|
          runs = csr_runs(psr)
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
          )
        end
      end

      def self.csr_runs(psr)
        psr.character_style_range.filter_map do |csr|
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
            strike_thru: csr.strike_thru,
            horizontal_scale: csr.horizontal_scale,
            vertical_scale: csr.vertical_scale,
            baseline_shift: csr.baseline_shift,
          )
        end
      end
      private_class_method :csr_runs

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
