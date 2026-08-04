# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::StructureTracker do
  describe "#enabled?" do
    it "returns true when constructed with enabled: true" do
      expect(described_class.new(enabled: true)).to be_enabled
    end

    it "returns false when constructed with enabled: false" do
      expect(described_class.new(enabled: false)).not_to be_enabled
    end

    it "defaults to disabled" do
      expect(described_class.new).not_to be_enabled
    end
  end

  describe "#next_mcid" do
    it "returns sequential MCIDs per page" do
      tracker = described_class.new(enabled: true)
      expect(tracker.next_mcid(0)).to eq(0)
      expect(tracker.next_mcid(0)).to eq(1)
      expect(tracker.next_mcid(0)).to eq(2)
    end

    it "keeps per-page counters independent" do
      tracker = described_class.new(enabled: true)
      expect(tracker.next_mcid(0)).to eq(0)
      expect(tracker.next_mcid(1)).to eq(0)
      expect(tracker.next_mcid(0)).to eq(1)
      expect(tracker.next_mcid(1)).to eq(1)
    end
  end

  describe "#add and #flush" do
    let(:writer) { FakeWriter.new }

    it "buffers entries until flush" do
      tracker = described_class.new(enabled: true)
      tracker.add(:P, page_index: 0, mcid: 0)
      tracker.add(:Figure, page_index: 0, mcid: 1, alt: "Photo")
      expect(writer.entries).to be_empty

      tracker.flush(writer)
      expect(writer.entries.length).to eq(2)
      expect(writer.entries.first).to include(type: :P, page_index: 0, mcid: 0)
      expect(writer.entries.last).to include(type: :Figure, alt: "Photo")
    end

    it "does nothing when disabled" do
      tracker = described_class.new(enabled: false)
      tracker.add(:P, page_index: 0, mcid: 0)
      tracker.flush(writer)
      expect(writer.entries).to be_empty
    end
  end
end

class FakeWriter
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_structure_element(type, page_index:, mcid:, text: nil, alt: nil)
    @entries << { type: type, page_index: page_index, mcid: mcid,
                  text: text, alt: alt }
  end
end
