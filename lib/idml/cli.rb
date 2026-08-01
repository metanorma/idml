# frozen_string_literal: true

require "thor"

module Idml
  # Command-line interface. Thin wrapper around the gem's public API —
  # no business logic lives here. Each subcommand is a Thor method that
  # delegates to Package, Document, Validation::Validator, or
  # Composition::Prefix.
  class CLI < Thor
    desc "version", "Print the idml gem version"
    def version
      puts Idml::VERSION
    end

    desc "parts PATH", "List every part in the IDML package"
    def parts(path)
      package(path).part_names.each { |name| puts name }
    end

    desc "validate PATH", "Validate every schematized part against RNG"
    def validate(path)
      validator = Idml::Validation::Validator.new
      results = validator.validate_package(package(path))
      any_failure = print_validation_results(results)
      exit 1 if any_failure
    end

    desc "round_trip PATH [-o OUTPUT]", "Extract every part and rezip"
    method_option :output, aliases: "-o", type: :string, required: true
    def round_trip(path)
      pkg = package(path)
      parts = pkg.each_part.to_a.to_h { |name, content| [name, content] }
      Idml::Package.write(parts: parts, to: options[:output])
      puts "Wrote #{options[:output]}"
    end

    desc "prefix PATH PREFIX [-o OUTPUT]", "Prefix every Self attribute"
    method_option :output, aliases: "-o", type: :string, required: true
    def prefix(path, prefix)
      result = Idml::Composition::Prefix.new(package(path)).call(prefix: prefix)
      FileUtils.cp(result.path, options[:output])
      puts "Wrote #{options[:output]}"
    end

    desc "text PATH [STORY_SELF]",
         "Print concatenated text of every story, or one"
    def text(path, story_self = nil)
      doc = Idml::Document.new(package(path))
      if story_self
        puts doc.story_text(story_self)
      else
        doc.each_story do |sid, body|
          puts "[#{sid}]"
          puts body
          puts
        end
      end
    end

    private

    def package(path)
      raise Idml::Errors::PackageNotFound, path unless File.exist?(path)

      Idml::Package.new(path)
    end

    def print_validation_results(results)
      results.partition(&:ok?).then do |ok, failed|
        ok.each { |r| puts "  OK   #{r.part_name}" }
        failed.each { |r| print_failure(r) }
        !failed.empty?
      end
    end

    def print_failure(result)
      puts "  FAIL #{result.part_name}"
      result.errors.each { |e| puts "       #{e}" }
    end
  end
end
