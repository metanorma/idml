# frozen_string_literal: true

require "spec_helper"

# Patterns checked below are forbidden in lib/. They break encapsulation
# (send, instance_variable_set/get), hide type errors (respond_to? for type
# checks), bypass the framework's type system (hand-rolled to_*/from_* on
# Serializable subclasses), or violate lazy-loading (require_relative in lib
# code). See CLAUDE.md for the full rationale.
RSpec.describe "Anti-patterns" do
  lib_dir = File.expand_path("../lib", __dir__)
  rb_files = Dir.glob(File.join(lib_dir, "**", "*.rb"))

  before do
    stub_const(
      "HAND_ROLLED_SERIALIZATION",
      %w[
        to_h to_hash from_h from_hash to_json from_json serialize deserialize
        to_xml from_xml
      ],
    )
    stub_const("ALLOWED_RESPOND_TO_USES", [])
  end

  rb_files.each do |path|
    rel = path.sub("#{lib_dir}/", "")
    source = File.read(path)

    describe rel do
      it "has no method_missing" do
        msg = "#{rel}: method_missing forbidden"
        expect(source).not_to include("method_missing"), msg
      end

      it "has no respond_to_missing?" do
        msg = "#{rel}: respond_to_missing? forbidden"
        expect(source).not_to include("respond_to_missing?"), msg
      end

      it "has no Object.const_get" do
        msg = "#{rel}: Object.const_get forbidden"
        expect(source).not_to include("Object.const_get"), msg
      end

      it "has no .send()" do
        msg = "#{rel}: .send() forbidden"
        expect(source).not_to include(".send("), msg
      end

      it "has no instance_variable_set or instance_variable_get" do
        msg = "#{rel}: instance_variable_set/get forbidden (breaks encapsulation)"
        expect(source).not_to match(/instance_variable_(set|get)/), msg
      end

      it "has no respond_to? type-checks" do
        pattern = /respond_to\(\?:[^)\s]+\)/
        matches = source.scan(pattern).map { |m| m&.first || m }
        violations = matches - ALLOWED_RESPOND_TO_USES
        msg = "#{rel}: respond_to? type-checks forbidden (use is_a?); found #{violations.inspect}"
        expect(violations).to be_empty, msg
      end

      it "has no hand-rolled serialization methods on Serializable subclasses" do
        # The check applies only to classes that inherit from
        # Lutaml::Model::Serializable. Plain wrapper classes (e.g. a raw
        # XML passthrough) may define from_xml/to_xml legitimately.
        next unless source.match?(/<\s*::?Lutaml::Model::Serializable/)

        violations = HAND_ROLLED_SERIALIZATION.select do |method|
          source.match?(/^\s*def\s+#{method}\b/)
        end
        expect(violations).to be_empty,
                              "#{rel}: hand-rolled serialization forbidden " \
                              "(use lutaml-model attribute + mapping); " \
                              "found #{violations.inspect}"
      end

      it "has no require_relative" do
        msg = "#{rel}: require_relative forbidden in lib/ (use autoload in the parent namespace)"
        expect(source).not_to include("require_relative"), msg
      end

      it "has no require with an internal library path" do
        # External gems and stdlib (lutaml, zip, fileutils, etc.) are fine;
        # internal paths (e.g. "idml/package") are not — use autoload.
        matches = source.scan(/^\s*require\s+["']([^"']+)["']/m)
        internal = matches.flatten.reject do |req|
          req.start_with?("lutaml", "nokogiri", "forwardable", "zip",
                          "fileutils", "tempfile", "open3", "thor") ||
            req == "json" || req == "set"
        end
        msg = "#{rel}: internal require forbidden (use autoload); found #{internal.inspect}"
        expect(internal).to be_empty, msg
      end
    end
  end
end
