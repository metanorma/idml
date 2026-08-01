# frozen_string_literal: true

module Idml
  module Parts
    autoload :Raw,       "idml/parts/raw"
    autoload :Designmap, "idml/parts/designmap"

    @registry = {}

    class << self
      def register(pattern, klass)
        @registry[pattern] = klass
      end

      def class_for(file_name)
        ensure_loaded
        _, klass = @registry.find { |pattern, _| pattern.match?(file_name) }
        klass
      end

      def all
        ensure_loaded
        @registry.values.uniq
      end

      private

      def ensure_loaded
        return if @loaded

        constants.each { |name| const_get(name) }
        @loaded = true
      end
    end
  end
end
