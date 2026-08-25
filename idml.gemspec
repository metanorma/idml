# frozen_string_literal: true

require_relative "lib/idml/version"

all_files_in_git = Dir.chdir(File.expand_path(__dir__)) do
  `git ls-files -z`.split("\x0")
end

Gem::Specification.new do |spec|
  spec.name = "idml"
  spec.version = Idml::VERSION
  spec.authors = ["Ribose"]
  spec.email = ["open.source@ribose.com"]

  spec.summary = "Parse, validate, compose, and render Adobe IDML files to PDF."
  spec.description = "Pure-Ruby toolkit for Adobe InDesign IDML: typed " \
    "schema-faithful models with byte-faithful round-trip, RelaxNG " \
    "validation, composition operations (insert_idml, " \
    "add_page_from_idml, XML import/export), and a full IDML-to-PDF " \
    "rendering pipeline (text layout, tables, CJK vertical writing, " \
    "text wrap, footnotes, gradients, tagged PDF, PDF/A)."
  spec.homepage      = "https://github.com/metanorma/idml"
  spec.license       = "BSD-2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = all_files_in_git
    .reject { |f| f.match(%r{\A(?:test|spec|features|bin|\.)/}) }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bigdecimal"
  spec.add_dependency "logger"
  spec.add_dependency "lutaml-model", "~> 0.8.18"
  spec.add_dependency "pdfrb", "~> 0.7"
  spec.add_dependency "rubyzip"
  spec.add_dependency "thor"

  spec.metadata["rubygems_mfa_required"] = "true"
end
