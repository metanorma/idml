# frozen_string_literal: true

module Idml
  module Parts
    autoload :Raw,          "idml/parts/raw"
    autoload :Designmap,    "idml/parts/designmap"
    autoload :Spread,       "idml/parts/spread"
    autoload :MasterSpread, "idml/parts/master_spread"
    autoload :Story,        "idml/parts/story"
    autoload :BackingStory, "idml/parts/backing_story"
    autoload :Fonts,        "idml/parts/fonts"
    autoload :Graphic,      "idml/parts/graphic"
    autoload :Style,        "idml/parts/style"
    autoload :StyleMapping, "idml/parts/style_mapping"
    autoload :Preferences,  "idml/parts/preferences"
    autoload :Tags,         "idml/parts/tags"
    autoload :Mapping,      "idml/parts/mapping"
    autoload :Xmp,            "idml/parts/xmp"
    autoload :XmpDescription, "idml/parts/xmp"
    autoload :XmpRdf,         "idml/parts/xmp"
    autoload :XmpMeta,        "idml/parts/xmp"

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
