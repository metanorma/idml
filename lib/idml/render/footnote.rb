# frozen_string_literal: true

module Idml
  module Render
    # Footnote semantics: story-scoped numbering, body-text marker
    # synthesis, footnote-paragraph extraction, and the geometry of
    # the bottom-of-frame footnote area (height reservation +
    # separator rule). Emission of footnote text lines stays in
    # TextFrameRenderer — it owns all canvas text drawing — while
    # this module owns everything footnote-specific (MECE).
    #
    # Numbering is sequential per story, honoring FootnoteOption's
    # StartAt / Prefix / Suffix when the package declares them.
    # Document-wide continuous numbering and per-section restart
    # are not modeled.
    module Footnote
      # One footnote collected during a frame's layout: its number
      # and its extracted (already marker-prefixed) paragraphs.
      Entry = Struct.new(:number, :paragraphs, keyword_init: true)

      # A positioned footnote line plus the run it came from — the
      # unit TextFrameRenderer emits.
      PositionedRun = Struct.new(:line, :run, :font_size, keyword_init: true)

      # Story-scoped sequential counter. Mutated as csr_runs walks
      # the story's style ranges so footnotes number in document
      # order across paragraphs.
      class Counter
        def initialize(start_at = nil)
          @next = start_at || 1
        end

        def next_number
          value = @next
          @next += 1
          value
        end
      end

      DEFAULT_RULE_WEIGHT = 0.5
      DEFAULT_RULE_GAP = 3.0
      MARKER_TEXT_SEPARATOR = " "

      # Returns the package's FootnoteOption (Preferences.xml), or
      # nil when the package doesn't declare one.
      def self.option(package)
        preferences = package&.preferences
        preferences&.footnote_option&.first
      end

      def self.counter_for(option)
        Counter.new(option&.start_at)
      end

      # Marker text shown in the body text (and prefixed to the
      # footnote's first paragraph): Prefix + number + Suffix.
      def self.marker_text(number, option)
        "#{option&.prefix}#{number}#{option&.suffix}"
      end

      # Builds the superscript marker run emitted into the body
      # text where the footnote anchors. Inherits the base run's
      # character styling so the marker matches its context; when
      # the owning CSR has no text run, falls back to defaults.
      def self.marker_run(number, base, paragraphs, option)
        marker = base || StyleResolver::StyledRun.new(
          point_size: StyleResolver::DEFAULT_POINT_SIZE,
        )
        marker = marker.dup
        marker.text = marker_text(number, option)
        marker.position = "Superscript"
        marker.footnote_number = number
        marker.footnote_paragraphs = paragraphs
        marker
      end

      # Extracts the footnote's paragraphs via StyleResolver and
      # prefixes the first paragraph's first run with the marker
      # text ("1 ", "n2." …) so the footnote reads as numbered.
      def self.extract(element, number, condition_filter: nil,
                       style_lookup: nil, option: nil)
        paragraphs = StyleResolver.extract_container_paragraphs(
          element, condition_filter: condition_filter,
                   style_lookup: style_lookup
        )
        marker = marker_text(number, option)
        prepend_marker(paragraphs, marker) unless marker.empty?
        paragraphs
      end

      def self.prepend_marker(paragraphs, marker)
        return if paragraphs.empty?
        return if paragraphs.first.runs.empty?

        first_run = paragraphs.first.runs.first
        first_run.text = "#{marker}#{MARKER_TEXT_SEPARATOR}#{first_run.text}"
      end
      private_class_method :prepend_marker

      # Lays out all entries' paragraphs top-down starting at
      # `top_y`. Returns `[positioned_runs, bottom_y]` where
      # bottom_y is the cursor after the last line — the same walk
      # drives both height measurement and rendering, so the
      # reserved area always matches what gets drawn.
      def self.layout_entries(entries, frame, font, top_y, option = nil)
        positioned = []
        cursor = top_y
        wrap_width = TextEngine::VerticalLayout.wrap_width(frame)

        entries.each_with_index do |entry, index|
          cursor -= (option&.space_between || 0).to_f if index.positive?
          entry.paragraphs.each do |paragraph|
            cursor = layout_paragraph(
              paragraph, frame, font, wrap_width, cursor, positioned
            )
          end
        end
        [positioned, cursor]
      end

      # Shapes, wraps, and positions one footnote paragraph,
      # appending its positioned lines. Returns the next cursor.
      def self.layout_paragraph(paragraph, frame, font, wrap_width, cursor,
                                positioned)
        paragraph.runs.each do |run|
          size = run.point_size || StyleResolver::DEFAULT_POINT_SIZE
          glyphs = TextEngine::Shaper.shape(text: run.text, font: font,
                                            size: size)
          lines = TextEngine::LineBreaker.break(glyphs: glyphs,
                                                frame_width: wrap_width)
          limits = TextEngine::Justifier::SpacingLimits.new(
            max_word_spacing: paragraph.maximum_word_spacing,
            max_letter_spacing: paragraph.maximum_letter_spacing,
          )
          lines.each_with_index do |line, index|
            TextEngine::Justifier.justify(
              line: line, frame_width: wrap_width,
              alignment: paragraph.alignment || :left,
              last_line: last_line?(paragraph, run, index, lines),
              limits: limits
            )
          end
          leading = TextEngine::VerticalLayout.leading_for(
            paragraph.auto_leading, size
          )
          block, cursor = TextEngine::VerticalLayout.layout_block(
            lines: lines, frame: frame, font_size: size, leading: leading,
            cursor_y: cursor
          )
          block.each do |line|
            positioned << PositionedRun.new(line: line, run: run,
                                            font_size: size)
          end
        end
        cursor
      end
      private_class_method :layout_paragraph

      # True for the final line of the footnote paragraph's final
      # run — kept ragged under full justification.
      def self.last_line?(paragraph, run, index, lines)
        run.equal?(paragraph.runs.last) && index == lines.length - 1
      end
      private_class_method :last_line?

      # Height to reserve at the frame bottom for the entries:
      # separator gap + the measured paragraph stack.
      def self.reserved_height(entries, font, frame, option = nil)
        return 0.0 if entries.empty?

        content_bottom = TextEngine::VerticalLayout.bottom_limit(frame)
        _, bottom_y = layout_entries(entries, frame, font, content_bottom,
                                     option)
        content_bottom - bottom_y + rule_gap(option)
      end

      # Vertical distance between the footnote area's top edge and
      # the first footnote line — room for the separator rule.
      def self.rule_gap(option)
        option&.spacer || DEFAULT_RULE_GAP
      end

      # Emits the separator rule at the top of the footnote area.
      # Honors FootnoteOption RuleOn / RuleLineWeight / RuleWidth /
      # RuleLeftIndent; defaults approximate InDesign (0.5pt rule
      # spanning the column).
      def self.emit_separator(canvas, frame, y, option)
        return if option&.rule_on == false

        thickness = separator_weight(option)
        return unless thickness.positive?

        stroke_rule(canvas, separator_left(frame, option), y,
                    separator_width(frame, option), thickness)
      end

      def self.separator_weight(option)
        (option&.rule_line_weight || DEFAULT_RULE_WEIGHT).to_f
      end
      private_class_method :separator_weight

      def self.separator_left(frame, option)
        TextEngine::VerticalLayout.frame_left(frame) +
          (option&.rule_left_indent || 0).to_f
      end
      private_class_method :separator_left

      def self.separator_width(frame, option)
        option&.rule_width ||
          TextEngine::VerticalLayout.wrap_width(frame)
      end
      private_class_method :separator_width

      def self.stroke_rule(canvas, left, y, width, thickness)
        canvas.stroke_color([:gray, 1.0])
        canvas.line_width = thickness
        canvas.move_to(left, y)
        canvas.line_to(left + width, y)
        canvas.stroke
      end
      private_class_method :stroke_rule
    end
  end
end
