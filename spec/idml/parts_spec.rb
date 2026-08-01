# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Parts do
  describe ".register / .class_for" do
    it "returns Designmap for designmap.xml" do
      expect(described_class.class_for("designmap.xml")).to eq(Idml::Parts::Designmap)
    end

    it "returns nil for an unknown part name" do
      expect(described_class.class_for("Resources/Unknown.xml")).to be_nil
    end

    it "memoizes load state (second call hits the populated registry)" do
      first = described_class.class_for("designmap.xml")
      second = described_class.class_for("designmap.xml")
      expect(second).to equal(first)
    end
  end

  describe ".all" do
    it "includes every registered part class" do
      expect(described_class.all).to include(Idml::Parts::Designmap)
    end

    it "excludes Raw (Raw is a fallback, not registered)" do
      expect(described_class.all).not_to include(Idml::Parts::Raw)
    end
  end
end
