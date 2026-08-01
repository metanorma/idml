# frozen_string_literal: true

module Idml
  module Composition
    class ExportXml
      def initialize(package)
        @package = package
      end

      def call(at: nil)
        raise NotImplementedError,
              "ExportXml is not yet implemented; " \
              "see TODO.complete/10-composition.md"
      end
    end
  end
end
