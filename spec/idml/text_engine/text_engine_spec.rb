# frozen_string_literal: true

require "spec_helper"

def pdfrb_metrics(font_path)
  skip "#{font_path} not available" unless File.exist?(font_path)

  doc = Pdfrb::Document.new
  resource = doc.fonts.add(font_path)
  Idml::TextEngine::PdfrbFontMetrics.new(doc.fonts, resource)
end

RSpec.describe Idml::TextEngine::Shaper do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:font) { pdfrb_metrics(font_path) }

  describe ".shape" do
    it "returns an array of ShapedGlyph objects" do
      glyphs = described_class.shape(text: "Hello", font: font, size: 12)
      expect(glyphs).to be_an(Array)
      expect(glyphs.first).to be_a(Idml::TextEngine::ShapedGlyph)
      expect(glyphs.length).to eq(5)
    end

    it "assigns a positive width to each glyph" do
      glyphs = described_class.shape(text: "A", font: font, size: 12)
      expect(glyphs.first.width).to be > 0
    end

    it "marks spaces as is_space" do
      glyphs = described_class.shape(text: "a b", font: font, size: 12)
      expect(glyphs[0].is_space).to be(false)
      expect(glyphs[1].is_space).to be(true)
    end
  end

  describe "#measure" do
    it "returns total width of glyphs" do
      shaper = described_class.new(font, 12)
      glyphs = shaper.shape("Hello")
      width = shaper.measure(glyphs)
      expect(width).to be > 0
    end
  end
end

RSpec.describe Idml::TextEngine::LineBreaker do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:font) { pdfrb_metrics(font_path) }

  it "breaks text into multiple lines when exceeding frame width" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("The quick brown fox jumps over the lazy dog")
    measure = shaper.measure(glyphs)
    narrow = measure / 3

    lines = described_class.break(glyphs: glyphs, frame_width: narrow)
    expect(lines.length).to be > 1
    expect(lines.first).to be_a(Idml::TextEngine::Line)
  end

  it "returns one line when text fits" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("Hi")
    wide = shaper.measure(glyphs) * 2

    lines = described_class.break(glyphs: glyphs, frame_width: wide)
    expect(lines.length).to eq(1)
  end
end

RSpec.describe Idml::TextEngine::Justifier do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:font) { pdfrb_metrics(font_path) }

  it "left-aligns by default (x_offset = 0)" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("Hello")
    line = Idml::TextEngine::Line.new(glyphs, shaper.measure(glyphs), 0)

    described_class.justify(line: line, frame_width: 500, alignment: :left)
    expect(line.x_offset).to eq(0)
  end

  it "centers the line in the frame" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("Hello")
    width = shaper.measure(glyphs)
    line = Idml::TextEngine::Line.new(glyphs, width, 0)

    described_class.justify(line: line, frame_width: 500, alignment: :center)
    expect(line.x_offset).to be_within(0.01).of((500 - width) / 2)
  end

  it "right-aligns the line" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("Hello")
    width = shaper.measure(glyphs)
    line = Idml::TextEngine::Line.new(glyphs, width, 0)

    described_class.justify(line: line, frame_width: 500, alignment: :right)
    expect(line.x_offset).to be_within(0.01).of(500 - width)
  end
end
