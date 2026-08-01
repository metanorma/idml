# frozen_string_literal: true

require "open3"

module Idml
  module Validation
    # Validates IDML parts against RelaxNG-Compact schemas using Jing.
    #
    # Jing is bundled in the InDesign Plug-in SDK at
    # `reference-docs/plugin_sdk_21/devtools/idmltools/jing/bin/jing.jar`.
    # The gem does not vendor Jing — users point Validator at a local
    # jar via the `jing_jar:` argument.
    #
    # Schemas are not vendored either. The default schema_root points at
    # the development tree; users override via `schema_root:`.
    class Validator
      DEFAULT_JING_JAR = File.expand_path(
        "../../../../reference-docs/plugin_sdk_21/" \
        "devtools/idmltools/jing/bin/jing.jar",
        __dir__,
      )

      NON_SCHEMATIZED_PARTS = %w[
        mimetype
        META-INF/container.xml
        META-INF/metadata.xml
      ].freeze

      SCHEMA_PATHS = {
        "designmap.xml" => ["designmap.rnc"],
        %r{\AMasterSpreads/} => ["MasterSpreads", "MasterSpread.rnc"],
        %r{\ASpreads/} => ["Spreads", "Spread.rnc"],
        %r{\AStories/} => ["Stories", "Story.rnc"],
        "Resources/Fonts.xml" => ["Resources", "Fonts.rnc"],
        "Resources/Graphic.xml" => ["Resources", "Graphic.rnc"],
        "Resources/Styles.xml" => ["Resources", "Styles.rnc"],
        "Resources/Preferences.xml" => ["Resources", "Preferences.rnc"],
        "XML/BackingStory.xml" => ["XML", "BackingStory.rnc"],
        "XML/Tags.xml" => ["XML", "Tags.rnc"],
        "XML/Mapping.xml" => ["XML", "Mapping.rnc"],
      }.freeze
      private_constant :SCHEMA_PATHS

      def initialize(schema_root: Idml::Validation::DEFAULT_SCHEMA_ROOT,
                     jing_jar: DEFAULT_JING_JAR)
        @schema_root = schema_root
        @jing_jar = jing_jar
      end

      attr_reader :schema_root, :jing_jar

      def validate_part(part_name, xml)
        schema = schema_path_for(part_name)
        unless schema
          return Result.new(part_name, false,
                            ["no schema mapping for #{part_name}"])
        end

        output, status = run_jing(schema, xml)
        ok = status.success? && output.empty?
        errors = ok ? [] : output.split("\n").grep(/error:/)
        Result.new(part_name, ok, errors)
      end

      # Tolerate DOMVersion mismatches by blanking the attribute before
      # validation. Useful for older IDML files: catches every schema
      # violation except version drift, which is expected.
      def loose_validate_part(part_name, xml)
        loosened = xml.gsub(/DOMVersion="[^"]*"/, 'DOMVersion=""')
        result = validate_part(part_name, loosened)
        return result if result.ok?

        non_version_errors = result.errors.reject do |e|
          e.include?("DOMVersion")
        end
        Result.new(part_name, non_version_errors.empty?, non_version_errors)
      end

      def validate_package(package)
        package.part_names.filter_map do |name|
          next if NON_SCHEMATIZED_PARTS.include?(name)

          validate_part(name, package.read_part(name))
        end
      end

      private

      def schema_path_for(part_name)
        _, segments = SCHEMA_PATHS.find do |pattern, _|
          if pattern.is_a?(Regexp)
            pattern.match?(part_name)
          else
            pattern == part_name
          end
        end
        return nil unless segments

        File.join(@schema_root, *segments)
      end

      def run_jing(schema, xml)
        raise JavaUnavailable, "java not found on PATH" unless java_available?

        Tempfile.create("idml-validate") do |tmp|
          tmp.write(xml)
          tmp.close
          stdout, status = Open3.capture2e("java", "-jar", @jing_jar, "-c",
                                           schema, tmp.path)
          [stdout, status]
        end
      end

      def java_available?
        ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |dir|
          File.executable?(File.join(dir, "java"))
        end
      end
    end
  end
end
