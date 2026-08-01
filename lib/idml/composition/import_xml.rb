# frozen_string_literal: true

module Idml
  module Composition
    class ImportXml
      def initialize(package)
        @package = package
      end

      def call(xml_string:, at:)
        raise NotImplementedError,
              "ImportXml is not yet implemented; " \
              "see TODO.complete/10-composition.md"
      end
    end
  end
end
