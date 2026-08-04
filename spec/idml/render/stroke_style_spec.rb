# frozen_string_literal: true

require "spec_helper"

FakeStrokeItem = Struct.new(
  :stroke_color, :stroke_weight, :end_cap, :end_join,
  :miter_limit, :stroke_dash_and_gap,
  keyword_init: true
)

RSpec.describe Idml::Render::StrokeStyle do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 200, height: 200) }

  before { allow(canvas).to receive(:line_cap=) }

  describe ".strokeable?" do
    it "returns true with a color and positive weight" do
      item = build_item(stroke_color: "Color/Black", stroke_weight: 2.0)
      expect(described_class.strokeable?(item)).to be true
    end

    it "returns false when color is nil" do
      item = build_item(stroke_color: nil, stroke_weight: 2.0)
      expect(described_class.strokeable?(item)).to be false
    end

    it "returns false when color is Color/None" do
      item = build_item(stroke_color: "Color/None", stroke_weight: 2.0)
      expect(described_class.strokeable?(item)).to be false
    end

    it "returns false when weight is zero" do
      item = build_item(stroke_color: "Color/Black", stroke_weight: 0.0)
      expect(described_class.strokeable?(item)).to be false
    end

    it "returns false when weight is nil" do
      item = build_item(stroke_color: "Color/Black", stroke_weight: nil)
      expect(described_class.strokeable?(item)).to be false
    end
  end

  describe ".apply" do
    it "yields and saves/restores graphics state" do
      item = build_item
      allow(canvas).to receive(:save_graphics_state).and_call_original
      expect { |b| described_class.apply(canvas, item, &b) }.to yield_control
    end

    it "sets line_cap for RoundEndCap" do
      item = build_item(end_cap: "RoundEndCap")
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).to have_received(:line_cap=).with(1)
    end

    it "sets line_join for BevelEndJoin" do
      item = build_item(end_join: "BevelEndJoin")
      allow(canvas).to receive(:line_join=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).to have_received(:line_join=).with(2)
    end

    it "sets miter_limit when >= 1" do
      item = build_item(miter_limit: 4.0)
      allow(canvas).to receive(:miter_limit=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).to have_received(:miter_limit=).with(4.0)
    end

    it "ignores miter_limit below 1" do
      item = build_item(miter_limit: 0.5)
      allow(canvas).to receive(:miter_limit=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).not_to have_received(:miter_limit=)
    end

    it "parses StrokeDashAndGap and sets dash_pattern" do
      item = build_item(stroke_dash_and_gap: "3 2 1 2")
      allow(canvas).to receive(:dash_pattern=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).to have_received(:dash_pattern=).with([[3.0, 2.0, 1.0, 2.0], 0])
    end

    it "ignores dash array with fewer than 2 entries" do
      item = build_item(stroke_dash_and_gap: "3")
      allow(canvas).to receive(:dash_pattern=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).not_to have_received(:dash_pattern=)
    end

    it "leaves canvas defaults when item has no stroke-style attrs" do
      item = build_item
      allow(canvas).to receive(:line_join=)
      allow(canvas).to receive(:miter_limit=)
      allow(canvas).to receive(:dash_pattern=)
      described_class.apply(canvas, item) { canvas.stroke }
      expect(canvas).not_to have_received(:line_cap=)
      expect(canvas).not_to have_received(:line_join=)
      expect(canvas).not_to have_received(:miter_limit=)
      expect(canvas).not_to have_received(:dash_pattern=)
    end
  end

  def build_item(overrides = {})
    FakeStrokeItem.new(
      { stroke_color: nil, stroke_weight: nil, end_cap: nil,
        end_join: nil, miter_limit: nil, stroke_dash_and_gap: nil }
        .merge(overrides),
    )
  end
end
