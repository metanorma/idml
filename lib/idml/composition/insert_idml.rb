# frozen_string_literal: true

module Idml
  module Composition
    # Stub. Future implementation will port SimpleIDML's
    # `IDMLPackage.insert_idml(source, at:, only:)` algorithm — copies
    # the source's `only` XPath subtree into the destination's `at`
    # XPath, after prefixing both packages to avoid Self collisions.
    class InsertIdml
      def initialize(package)
        @package = package
      end

      def call(source:, at:, only:)
        raise NotImplementedError,
              "InsertIdml is not yet implemented; " \
              "see TODO.complete/10-composition.md"
      end
    end
  end
end
