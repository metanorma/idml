# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::PositionTracker do
  let(:tracker) { described_class.new }

  describe "#add and #ranges_for" do
    it "returns ranges in the order they were added" do
      tracker.add("frame1", start_char: 0, end_char: 5, x: 10, y: 20,
                            width: 100, height: 12)
      tracker.add("frame1", start_char: 5, end_char: 10, x: 10, y: 35,
                            width: 100, height: 12)

      ranges = tracker.ranges_for("frame1")
      expect(ranges.length).to eq(2)
      expect(ranges.first.start_char).to eq(0)
      expect(ranges.last.start_char).to eq(5)
    end

    it "returns [] for an unknown frame" do
      expect(tracker.ranges_for("unknown")).to eq([])
    end

    it "separates ranges by frame Self" do
      tracker.add("frame1", start_char: 0, end_char: 3, x: 0, y: 0,
                            width: 10, height: 10)
      tracker.add("frame2", start_char: 0, end_char: 3, x: 50, y: 50,
                            width: 10, height: 10)

      expect(tracker.ranges_for("frame1").first.x).to eq(0)
      expect(tracker.ranges_for("frame2").first.x).to eq(50)
    end
  end

  describe "#rect_for_range" do
    before do
      tracker.add("frame1", start_char: 0, end_char: 5, x: 10, y: 700,
                            width: 80, height: 12)
      tracker.add("frame1", start_char: 5, end_char: 12, x: 10, y: 680,
                            width: 200, height: 12)
      tracker.add("frame1", start_char: 12, end_char: 20, x: 10, y: 660,
                            width: 50, height: 12)
    end

    it "returns the bounding rect for ranges overlapping the query" do
      rect = tracker.rect_for_range("frame1", from: 0, to: 5)
      expect(rect).to eq([10, 700, 90, 712])
    end

    it "unions multiple ranges when query spans them" do
      rect = tracker.rect_for_range("frame1", from: 0, to: 12)
      expect(rect).to eq([10, 680, 210, 712])
    end

    it "returns nil when no range overlaps" do
      rect = tracker.rect_for_range("frame1", from: 100, to: 200)
      expect(rect).to be_nil
    end

    it "returns nil for unknown frame" do
      expect(tracker.rect_for_range("unknown", from: 0, to: 5)).to be_nil
    end
  end

  describe "#clear" do
    it "removes all recorded ranges" do
      tracker.add("frame1", start_char: 0, end_char: 5, x: 0, y: 0,
                            width: 10, height: 10)
      tracker.clear
      expect(tracker.ranges_for("frame1")).to eq([])
    end
  end
end
