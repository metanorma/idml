# frozen_string_literal: true

module Idml
  module Render
    # Allocates MCID integers per page and buffers structure-element
    # registrations until `Pipeline` is ready to flush them. Created
    # once per pipeline run; `enabled?` is false when `tagged:` was
    # not requested, in which case every method is a no-op.
    class StructureTracker
      def initialize(enabled: false)
        @enabled = enabled
        @entries = []
        @page_mcids = Hash.new(0)
      end

      def enabled?
        @enabled
      end

      # Returns the next MCID for the given page index. MCIDs are
      # per-page in PDF (reset to 0 on each new page).
      def next_mcid(page_index)
        current = @page_mcids[page_index]
        @page_mcids[page_index] = current + 1
        current
      end

      def add(type, page_index:, mcid:, text: nil, alt: nil)
        return unless @enabled

        @entries << Entry.new(type, page_index, mcid, text, alt)
      end

      # Push buffered entries into the writer in registration order.
      def flush(writer)
        return unless @enabled

        @entries.each do |entry|
          writer.add_structure_element(entry.type, page_index: entry.page_index,
                                                   mcid: entry.mcid,
                                                   text: entry.text,
                                                   alt: entry.alt)
        end
      end

      Entry = Struct.new(:type, :page_index, :mcid, :text, :alt, keyword_init: true) do
        def initialize(type, page_index, mcid, text, alt)
          super(type: type, page_index: page_index, mcid: mcid,
                text: text, alt: alt)
        end
      end
      private_constant :Entry
    end
  end
end
