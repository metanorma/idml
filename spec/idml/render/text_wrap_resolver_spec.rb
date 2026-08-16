# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::TextWrapResolver do
  describe "#overlap_width" do
    let(:contour) do
      described_class::Contour.new(x: 100, y: 300, width: 50, height: 100)
    end

    it "returns 0 when line does not overlap contour vertically" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(100, 12, 0, 400)).to eq(0)
    end

    it "returns 0 when line does not overlap contour horizontally" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(350, 12, 0, 80)).to eq(0)
    end

    it "returns full contour width when line is inside contour" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(50)
    end

    it "returns partial width when contour extends past frame right" do
      wide = described_class::Contour.new(x: 380, y: 300, width: 100,
                                          height: 100)
      resolver = described_class.new([wide])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(20)
    end

    it "sums multiple overlapping contours" do
      second = described_class::Contour.new(x: 200, y: 300, width: 30,
                                            height: 100)
      resolver = described_class.new([contour, second])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(80)
    end

    it "returns 0 with no contours" do
      resolver = described_class.new([])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(0)
    end
  end

  describe ".build" do
    it "returns resolver with no contours for spread without wrap prefs" do
      spread = Idml::Parts::Spread.from_xml(
        '<idPkg:Spread xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging">
          <Spread Self="s1"/>
        </idPkg:Spread>',
      )
      resolver = described_class.build(spread)
      expect(resolver.contours).to be_empty
    end
  end
end
