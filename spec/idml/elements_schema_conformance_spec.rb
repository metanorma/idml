# frozen_string_literal: true

require "spec_helper"

# Schema conformance for the Elements layer (TODO 151): the
# committed package RNC schemas are the authoritative interface of
# every element class. These specs defend against drift — a
# hand-edited class whose wire attributes leave the schema
# universe (typos, inventions) fails here with the exact delta.
#
# Full per-class equality is NOT asserted: many classes
# deliberately model a subset of their schema element, and the
# RNC composes some attributes via typedefs the direct scan
# doesn't inline. The enforceable contract is "no attribute
# outside the schema" plus internal mapping/declaration
# consistency.
RSpec.describe Idml::Elements do
  def rnc_paths
    Dir[File.expand_path("../../reference-docs/schemas/package/**/*.rnc",
                         __dir__)]
  end

  def schema_universe
    rnc_paths.flat_map do |path|
      File.read(path).scan(/attribute\s+(\w+)\s*\{/)
    end.flatten.uniq
  end

  # Attributes of classes that model LEGACY synthetic-fixture
  # structures with no schema backing (the pre-schema table path).
  def non_schema_attrs
    {
      "Idml::Elements::TableCell" => %w[Column Row KeyValue],
    }
  end

  def element_classes
    Idml::Elements.constants.sort.map { |c| Idml::Elements.const_get(c) }
      .grep(Class)
      .select { |k| k < Lutaml::Model::Serializable }
      .uniq
      .select { |k| xml_mapping(k)&.root_element }
  end

  def xml_mapping(klass)
    klass.mappings[:xml]
  rescue StandardError
    nil
  end

  describe "inventory" do
    it "enumerates the full element-class inventory" do
      expect(element_classes.length).to be >= 140
    end
  end

  describe "wire attributes stay inside the schema universe" do
    it "has no invented or misspelled map_attribute names" do
      universe = schema_universe
      offenders = {}
      element_classes.each do |klass|
        wire = xml_mapping(klass).attributes.map(&:name).uniq
        allowed = non_schema_attrs[klass.name] || []
        outside = wire - universe - allowed
        offenders[klass.name] = outside if outside.any?
      end
      expect(offenders).to eq({})
    end
  end

  describe "mapping and declaration consistency" do
    it "maps every wire attribute onto a declared attribute" do
      offenders = {}
      element_classes.each do |klass|
        declared = klass.attributes.keys
        mapped = xml_mapping(klass).attributes.map(&:to)
        stray = mapped - declared
        offenders[klass.name] = stray if stray.any?
      end
      expect(offenders).to eq({})
    end
  end

  describe Idml::Schema::Rnc do
    it "extracts element definitions across part files" do
      map = described_class.element_attribute_map(rnc_paths)
      expect(map["Story"]).not_to be_empty
      story_alt = map["Story"].find { |alt| alt.include?("Self") }
      expect(story_alt).to include("FirstLineIndent")
      expect(map["MojikumiTable"].first).to eq(
        %w[Self Name BasedOnMojikumiSet],
      )
      # Elements defined in several part files keep each
      # definition as an alternative.
      expect(map["TextFramePreference"].length).to be > 1
    end

    it "extracts one named definition with its types" do
      designmap = rnc_paths.find { |path| path.end_with?("designmap.rnc") }
      _root, attrs = described_class.element_definition(
        designmap, "MojikumiTable_Object"
      )
      expect(attrs).to eq(
        [["Self", "xsd:string"], ["Name", "xsd:string"],
         ["BasedOnMojikumiSet", "MojikumiTableDefaults_EnumValue"]],
      )
    end
  end
end
