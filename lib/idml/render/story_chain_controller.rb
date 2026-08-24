# frozen_string: true

module Idml
  module Render
    # Threads story-rendering state across linked TextFrames in a
    # chain. A story overflows from frame 1 → frame 2 → frame 3 etc.
    # via PreviousTextFrame/NextTextFrame links; without chain
    # awareness, the renderer would silently truncate overflow text.
    #
    # State is per story_id (the ParentStory attribute). State is
    # populated when a chain head renders and consumed when chain
    # non-head frames render.
    #
    # Threading granularity: paragraphs and runs. If a run partially
    # fits in a frame, the next frame picks up where the previous
    # left off (the partially-rendered lines stay in the previous
    # frame; remaining lines come from re-wrapping the run).
    class StoryChainController
      # `paragraphs` : Array<Paragraph> not yet started
      # `current_paragraph` : Paragraph in progress (nil if none)
      # `runs_remaining` : Array<StyledRun> in current_paragraph not yet rendered
      # `char_cursor` : global character cursor (for hyperlink tracking)
      State = Struct.new(
        :paragraphs,
        :current_paragraph,
        :runs_remaining,
        :char_cursor,
        # Vertical-writing path: columns already consumed when the
        # paragraph chain continues into the next frame.
        :column_offset,
        # Frame-spanning tables: [table, start_row] pairs still to
        # render (TODO 134).
        :tables_remaining,
        keyword_init: true,
      )

      def initialize
        @states = {}
      end

      # Returns the chain state for a story, or nil if the story has
      # no leftover content. Chain heads (no predecessor) get no
      # state — they render from scratch.
      def state_for(story_id)
        @states[story_id]
      end

      # Records the chain state for a story after a frame's render.
      # Removes the state entirely when no content remains.
      def store_state(story_id, state)
        if state.nil? || empty_state?(state)
          @states.delete(story_id)
        else
          @states[story_id] = state
        end
      end

      # True when a story has pending content from a previous frame.
      def has_pending?(story_id)
        @states.key?(story_id)
      end

      private

      def empty_state?(state)
        state.paragraphs.empty? &&
          state.current_paragraph.nil? &&
          state.runs_remaining&.empty?
      end
    end
  end
end
