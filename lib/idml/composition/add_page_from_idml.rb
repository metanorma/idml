# frozen_string_literal: true

module Idml
  module Composition
    class AddPageFromIdml
      def initialize(package)
        @package = package
      end

      def call(source:, page_number:, at:, only:)
        raise NotImplementedError,
              "AddPageFromIdml is not yet implemented; " \
              "see TODO.complete/10-composition.md"
      end
    end
  end
end
