# frozen_string: true

module Idml
  module Render
    # Produces a list-marker string for a paragraph (bullet glyph or
    # numbered-list expression). IDML stores the resolved marker
    # directly on the PSR (BulletCharacterValue as a Unicode codepoint,
    # NumberingExpression as the rendered text), so the renderer
    # doesn't need to maintain its own counter.
    #
    # Used by `StyleResolver` to prepend the marker to the paragraph's
    # first run's text. The marker becomes part of the run's natural
    # text flow — no special positioning needed for MVP.
    #
    # Hanging-indent layout (bullet aligned in a left gutter with
    # wrapped lines indented to align with text after the marker) is
    # a follow-up; for now the marker sits inline before the text.
    module ListMarker
      DEFAULT_BULLET = "•".freeze # BULLET
      DEFAULT_TEXT_AFTER = "\t".freeze

      # Returns the marker string for the paragraph, or nil when the
      # paragraph isn't part of a list.
      def self.marker_for(paragraph)
        return nil unless paragraph

        case paragraph.bullets_and_numbering_list_type
        when "BulletList" then bullet_marker(paragraph)
        when "NumberedList" then numbered_marker(paragraph)
        end
      end

      def self.bullet_marker(paragraph)
        bullet = bullet_char(paragraph)
        suffix = text_after(paragraph)
        "#{bullet}#{suffix}"
      end
      private_class_method :bullet_marker

      def self.numbered_marker(paragraph)
        expr = paragraph.numbering_expression
        return nil if expr.nil? || expr.empty?

        suffix = text_after(paragraph)
        "#{expr}#{suffix}"
      end
      private_class_method :numbered_marker

      def self.bullet_char(paragraph)
        codepoint = paragraph.bullet_character_value
        return DEFAULT_BULLET unless codepoint&.positive?

        [codepoint].pack("U")
      end
      private_class_method :bullet_char

      def self.text_after(paragraph)
        paragraph.bullets_text_after || DEFAULT_TEXT_AFTER
      end
      private_class_method :text_after
    end
  end
end
