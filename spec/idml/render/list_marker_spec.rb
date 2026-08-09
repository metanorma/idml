# frozen_string: true

require "spec_helper"

RSpec.describe Idml::Render::ListMarker do
  def paragraph(overrides = {})
    attrs = { runs: [], alignment: :left }.merge(overrides)
    Idml::Render::StyleResolver::Paragraph.new(**attrs)
  end

  describe ".marker_for" do
    it "returns nil when paragraph isn't a list" do
      expect(described_class.marker_for(paragraph)).to be_nil
      expect(described_class.marker_for(
               paragraph(bullets_and_numbering_list_type: "None"),
             )).to be_nil
    end

    it "returns nil for nil paragraph" do
      expect(described_class.marker_for(nil)).to be_nil
    end

    it "produces a bullet marker for BulletList" do
      result = described_class.marker_for(
        paragraph(
          bullets_and_numbering_list_type: "BulletList",
          bullet_character_value: 0x2022, # U+2022 BULLET
          bullets_text_after: " ",
        ),
      )
      expect(result).to eq("• ")
    end

    it "uses default bullet when BulletCharacterValue is nil" do
      result = described_class.marker_for(
        paragraph(bullets_and_numbering_list_type: "BulletList"),
      )
      expect(result).to start_with("•")
    end

    it "uses default text-after (tab) when BulletsTextAfter is nil" do
      result = described_class.marker_for(
        paragraph(
          bullets_and_numbering_list_type: "BulletList",
          bullet_character_value: 0x2022,
        ),
      )
      expect(result).to eq("•\t")
    end

    it "produces a numbered marker from NumberingExpression" do
      result = described_class.marker_for(
        paragraph(
          bullets_and_numbering_list_type: "NumberedList",
          numbering_expression: "1.",
          bullets_text_after: " ",
        ),
      )
      expect(result).to eq("1. ")
    end

    it "returns nil for NumberedList without NumberingExpression" do
      expect(described_class.marker_for(
               paragraph(bullets_and_numbering_list_type: "NumberedList"),
             )).to be_nil
    end

    it "returns nil for empty NumberingExpression" do
      expect(described_class.marker_for(
               paragraph(
                 bullets_and_numbering_list_type: "NumberedList",
                 numbering_expression: "",
               ),
             )).to be_nil
    end
  end
end
