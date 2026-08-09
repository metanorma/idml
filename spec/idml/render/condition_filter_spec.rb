# frozen_string: true

require "spec_helper"

# Lightweight designmap stub: real Designmap parses XML; the filter
# only needs the `condition` collection. Struct lives at top level
# (not inside the RSpec block) per rubocop convention.
ConditionFilterFakeDesignmap = Struct.new(:condition, keyword_init: true)

RSpec.describe Idml::Render::ConditionFilter do
  def condition(self_attr, visible: true)
    Idml::Elements::Condition.new.tap do |c|
      c.self_attr = self_attr
      c.visible = visible
    end
  end

  describe ".from_designmap" do
    it "returns a filter that indexes conditions by Self" do
      designmap = ConditionFilterFakeDesignmap.new(
        condition: [
          condition("c-visible", visible: true),
          condition("c-hidden", visible: false),
        ],
      )
      filter = described_class.from_designmap(designmap)
      expect(filter.visible?("c-visible")).to be true
      expect(filter.visible?("c-hidden")).to be false
    end

    it "handles nil designmap" do
      filter = described_class.from_designmap(nil)
      expect(filter.visible?("anything")).to be true
    end
  end

  describe "#visible?" do
    let(:filter) do
      described_class.new([
                            condition("c1", visible: true),
                            condition("c2", visible: false),
                          ])
    end

    it "returns true when no conditions applied (nil)" do
      expect(filter.visible?(nil)).to be true
    end

    it "returns true when conditions string is empty/whitespace" do
      expect(filter.visible?("")).to be true
      expect(filter.visible?("   ")).to be true
    end

    it "returns true when all referenced conditions are visible" do
      expect(filter.visible?("c1")).to be true
    end

    it "returns false when any referenced condition is hidden" do
      expect(filter.visible?("c2")).to be false
      expect(filter.visible?("c1 c2")).to be false
    end

    it "returns true for unknown conditions (treats them as visible)" do
      expect(filter.visible?("unknown-condition")).to be true
    end

    it "handles space-separated list of conditions" do
      expect(filter.visible?("c1 other-visible")).to be true
    end
  end
end
