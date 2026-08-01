# frozen_string_literal: true

require "spec_helper"

# Verifies every typed element class in Idml::Elements can parse a
# minimal valid XML fragment for its root. Catches codegen bugs that
# produce syntactically valid but semantically broken Ruby (wrong
# root name, missing namespace, etc.).
RSpec.describe "Idml::Elements — every class parses" do
  before(:all) do
    # Force every autoload to resolve so constants.each sees them all.
    Idml::Elements.constants.each { |c| Idml::Elements.const_get(c) }
  end

  # Discover the XML root name for a class by reading its xml mapping.
  def xml_root_for(klass)
    mapping = klass.instance_variable_get(:@xml_mappings)
    return klass.name.split("::").last unless mapping

    root = mapping.root_name if mapping.respond_to?(:root_name)
    root || klass.name.split("::").last
  end

  Idml::Elements.constants.each do |const_name|
    klass = Idml::Elements.const_get(const_name)
    next unless klass.is_a?(Class)
    next unless klass < Lutaml::Model::Serializable

    describe klass.name do
      it "is a Lutaml::Model::Serializable subclass" do
        expect(klass).to be < Lutaml::Model::Serializable
      end

      it "parses a minimal XML fragment for its root" do
        root = xml_root_for(klass)
        xml = %(<#{root} Self="smoke-test"/>)
        expect { klass.from_xml(xml) }.not_to raise_error
      end
    end
  end
end
