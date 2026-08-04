# frozen_string_literal: true

require "spec_helper"
require "bigdecimal"

RSpec.describe Idml::Parts::Designmap do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:designmap) { package.part("designmap.xml") }

  it "is a Lutaml::Model::Serializable" do
    expect(described_class).to be < Lutaml::Model::Serializable
  end

  it "includes Idml::Part (registers itself with Parts)" do
    expect(Idml::Parts.class_for("designmap.xml")).to eq(described_class)
  end

  describe "attribute set" do
    it "declares the document-level attributes from the RNG schema" do
      expected = %i[
        dom_version self_attr story_list full_name visible file_path
        modified saved name zero_point active_layer unused_swatches
        converted recovered read_only id_attr cmyk_profile_list
        rgb_profile_list cmyk_profile rgb_profile solid_color_intent
        after_blending_intent default_image_intent rgb_policy cmyk_policy
        accurate_lab_spots selected_page_items
        transparency_attribute_default_property applied_math_ml_font_size
        applied_math_ml_rgb_color tint_value prefer_math_ml_in_epub_export
        active_process layer
      ].each(&:to_s)
      expect(described_class.attributes.keys).to match_array(expected)
    end
  end

  describe "parsing the fixture" do
    it "extracts DOMVersion" do
      expect(designmap.dom_version).to eq("21.5")
    end

    it "extracts Self" do
      expect(designmap.self_attr).to eq("d")
    end

    it "extracts Name" do
      expect(designmap.name).to eq("sample-with-image.indd")
    end

    it "extracts ActiveLayer" do
      expect(designmap.active_layer).to eq("uce")
    end

    it "extracts CMYKProfile" do
      expect(designmap.cmyk_profile).to eq("U.S. Web Coated (SWOP) v2")
    end

    it "extracts AccurateLABSpots as boolean false" do
      expect(designmap.accurate_lab_spots).to be(false)
    end

    it "extracts TintValue as a decimal" do
      expect(designmap.tint_value).to eq(BigDecimal(100))
    end
  end

  describe ".from_xml / .to_xml on the attributes we model" do
    it "round-trips the modeled attributes through XML" do
      original = package.read_part("designmap.xml")
      parsed = described_class.from_xml(original)
      reserialized = described_class.to_xml(parsed)

      expected_attrs = %w[DOMVersion Self Name ActiveLayer CMYKProfile]
      expected_attrs.each do |attr|
        ruby_attr = read_attr(parsed, attr)
        expect(reserialized).to include(%(#{attr}="#{ruby_attr}"))
      end
    end
  end

  def read_attr(designmap, xml_attr)
    case xml_attr
    when "DOMVersion" then designmap.dom_version
    when "Self" then designmap.self_attr
    when "Name" then designmap.name
    when "ActiveLayer" then designmap.active_layer
    when "CMYKProfile" then designmap.cmyk_profile
    end
  end
end
