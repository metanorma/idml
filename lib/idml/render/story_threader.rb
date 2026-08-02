# frozen_string_literal: true

module Idml
  module Render
    # Builds text frame chains from PreviousTextFrame/NextTextFrame
    # links. A story flows across linked frames: the first frame gets
    # lines that fit, overflow goes to the next frame, and so on.
    class StoryThreader
      Thread = Struct.new(:story_id, :frames, keyword_init: true)

      def self.build_chains(spread)
        chains = []
        return chains unless spread

        frames_by_id = collect_text_frames(spread)
        frames_by_id.each_value do |frame|
          next unless chain_head?(frame)

          chains << build_chain(frame, frames_by_id)
        end
        chains
      end

      # A chain head has previous_text_frame == "n" (no predecessor).
      def self.chain_head?(frame)
        frame.previous_text_frame.nil? || frame.previous_text_frame == "n"
      end
      private_class_method :chain_head?

      def self.build_chain(head, frames_by_id)
        frames = []
        current = head
        while current && !frames.include?(current)
          frames << current
          next_id = current.next_text_frame
          break if next_id.nil? || next_id == "n"

          current = frames_by_id[next_id]
        end
        Thread.new(story_id: head.parent_story, frames: frames)
      end
      private_class_method :build_chain

      def self.collect_text_frames(spread)
        result = {}
        spread.each_page_item do |item|
          next unless item.is_a?(Idml::Elements::TextFrame)

          result[item.self_attr] = item
        end
        result
      end
      private_class_method :collect_text_frames
    end
  end
end
