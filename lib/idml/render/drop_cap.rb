# frozen_string: true

module Idml
  module Render
    # Computes drop-cap geometry for a paragraph. IDML's DropCapLines
    # (M) and DropCapCharacters (N) declare that the first N
    # characters of the paragraph should render at M-lines-tall and
    # the next M text lines should wrap to the right of the drop cap.
    #
    # The helper returns a `DropCapLayout` struct with the drop cap
    # text, font size, width (for wrap offset), and total height.
    # Returns nil when the paragraph doesn't declare drop caps.
    module DropCap
      DropCapLayout = Struct.new(
        :text, :width, :height, :font_size, :wrap_offset, :lines,
        keyword_init: true
      )

      # Returns a DropCapLayout for the paragraph, or nil when drop
      # caps aren't declared. `font_metrics` measures the drop-cap
      # text's natural width. `base_size` is the paragraph's normal
      # font size (drop cap is enlarged relative to it).
      def self.layout(paragraph, font_metrics:, base_size:, leading:)
        return nil unless active?(paragraph)
        return nil unless font_metrics

        chars = paragraph.drop_cap_characters.to_i
        lines = paragraph.drop_cap_lines.to_i
        return nil if chars <= 0 || lines <= 0

        build_layout(paragraph, font_metrics, base_size, leading, chars, lines)
      end

      # True when the paragraph declares an active drop cap
      # (both DropCapLines and DropCapCharacters are positive integers).
      def self.active?(paragraph)
        return false unless paragraph
        return false unless paragraph.drop_cap_lines.to_i.positive?

        paragraph.drop_cap_characters.to_i.positive?
      end

      # Pulls the first N characters from the paragraph's first run.
      # If the first run is shorter than N, takes from subsequent runs
      # until N chars are accumulated (rare — drop caps typically use
      # 1-2 chars).
      def self.extract_drop_cap_text(paragraph, n)
        runs = paragraph.runs
        return nil if runs.empty?

        collected = +""
        runs.each do |run|
          needed = n - collected.length
          break if needed <= 0

          collected << run.text[0, needed]
          break if collected.length >= n
        end
        collected
      end

      def self.build_layout(paragraph, font_metrics, base_size, leading,
                            chars, lines)
        text = extract_drop_cap_text(paragraph, chars)
        return nil if text.nil? || text.empty?

        font_size = base_size * lines
        width = font_metrics.measure_text(text, font_size).to_f
        return nil unless width&.positive?

        DropCapLayout.new(
          text: text,
          width: width,
          height: leading * lines,
          font_size: font_size,
          wrap_offset: width,
          lines: lines,
        )
      end
      private_class_method :build_layout
    end
  end
end
