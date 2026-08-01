# frozen_string_literal: true

module Idml
  # Mixin for every part class (typed or raw). Provides the `part_file`
  # class-level macro that registers the class against a filename pattern
  # in Idml::Parts. New part classes self-register; nothing else in the
  # codebase needs to change when adding one (open/closed).
  module Part
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def part_file(pattern)
        reg = pattern.is_a?(Regexp) ? pattern : /\A#{Regexp.escape(pattern)}\z/
        Idml::Parts.register(reg, self)
      end
    end
  end
end
