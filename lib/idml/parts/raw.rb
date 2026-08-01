# frozen_string_literal: true

module Idml
  module Parts
    # Fallback part class for entries the gem does not yet model typed.
    # Wraps the raw XML verbatim — lossless round-trip, no typed access.
    # As typed models are added under Idml::Parts::*, fewer entries will
    # route through Raw.
    class Raw
      include Idml::Part

      def initialize(xml)
        @xml = xml
      end

      attr_reader :xml

      def self.from_xml(xml)
        new(xml)
      end

      def to_xml(*)
        @xml
      end
    end
  end
end
