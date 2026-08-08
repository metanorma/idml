# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::TextEngine::VerticalLayout do
  let(:frame) do
    Idml::TextEngine::Frame.new(x: 72, y: 720, width: 468, height: 648)
  end

  let(:two_glyph_line) do
    Idml::TextEngine::Line.new(
      [
        Idml::TextEngine::ShapedGlyph.new("H".ord, 7, false),
        Idml::TextEngine::ShapedGlyph.new("i".ord, 4, false),
      ],
      11, 0
    )
  end

  def line(char, width = 7)
    Idml::TextEngine::Line.new(
      [Idml::TextEngine::ShapedGlyph.new(char.ord, width, false)],
      width, 0
    )
  end

  describe ".layout_block" do
    it "positions glyphs on the same line with identical Y" do
      positioned, _next_y = described_class.layout_block(
        lines: [two_glyph_line], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720
      )
      expect(positioned.length).to eq(1)
      expect(positioned.first.y).to eq(720 - 14.4)
      expect(positioned.first.x).to eq(72)
      expect(positioned.first.width).to eq(11)
    end

    it "positions lines on descending Y values" do
      positioned, _next_y = described_class.layout_block(
        lines: [line("A"), line("B")], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720
      )
      expect(positioned.first.y).to be > positioned.last.y
      expect(positioned.last.y).to eq(720 - (14.4 * 2))
    end

    it "subtracts space_before before the first line" do
      positioned, _next_y = described_class.layout_block(
        lines: [line("A")], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720, space_before: 10
      )
      expect(positioned.first.y).to eq(720 - 10 - 14.4)
    end

    it "returns next_y below the last line plus space_after" do
      _positioned, next_y = described_class.layout_block(
        lines: [line("A"), line("B")], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720, space_after: 8
      )
      # last line y = 720 - 14.4 - 14.4 = 691.2
      # next_y = 691.2 - 8 = 683.2
      expect(next_y).to eq(720 - (14.4 * 2) - 8)
    end

    it "applies first_line_indent only on the first line" do
      positioned, _next_y = described_class.layout_block(
        lines: [line("A"), line("B")], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720, first_line_indent: 24
      )
      expect(positioned.first.x).to eq(72 + 24)
      expect(positioned.last.x).to eq(72)
    end

    it "applies left_indent on every line" do
      positioned, _next_y = described_class.layout_block(
        lines: [line("A"), line("B")], frame: frame, font_size: 12,
        leading: 14.4, cursor_y: 720, left_indent: 18
      )
      expect(positioned.first.x).to eq(72 + 18)
      expect(positioned.last.x).to eq(72 + 18)
    end

    it "subtracts frame inset_left from the left edge" do
      inset_frame = Idml::TextEngine::Frame.new(
        x: 72, y: 720, width: 468, height: 648, inset_left: 15,
      )
      positioned, _next_y = described_class.layout_block(
        lines: [line("A")], frame: inset_frame, font_size: 12,
        leading: 14.4, cursor_y: 720
      )
      expect(positioned.first.x).to eq(72 + 15)
    end
  end

  describe ".bottom_limit" do
    it "returns frame bottom when no inset" do
      expect(described_class.bottom_limit(frame)).to eq(720)
    end

    it "adds inset_bottom to frame bottom" do
      inset_frame = Idml::TextEngine::Frame.new(
        x: 72, y: 720, width: 468, height: 648, inset_bottom: 12,
      )
      expect(described_class.bottom_limit(inset_frame)).to eq(720 + 12)
    end
  end

  describe ".wrap_width" do
    it "subtracts left and right insets" do
      inset_frame = Idml::TextEngine::Frame.new(
        x: 72, y: 720, width: 468, height: 648,
        inset_left: 10, inset_right: 10
      )
      expect(described_class.wrap_width(inset_frame)).to eq(448)
    end

    it "subtracts paragraph right_indent when given" do
      expect(described_class.wrap_width(frame, 20)).to eq(448)
    end
  end
end
