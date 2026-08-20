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

  describe "kinsoku shori for CJK runs" do
    def glyph(char, width = 10.0)
      Idml::TextEngine::ShapedGlyph.new(char.ord, width, char == " ")
    end

    it "moves a forbidden line-start character to the previous line" do
      # Per-character CJK break lands before 。 (glyph 6 at width 55
      # overflows a 50pt line); kinsoku then pulls 。 up.
      glyphs = "一二三四五。六七八".each_char.map { |c| glyph(c) }
      lines = described_class.break(glyphs: glyphs, frame_width: 50)

      expect(lines.first.glyphs.last.codepoint).to eq("。".ord)
      expect(lines.last.glyphs.first.codepoint).to eq("六".ord)
    end

    it "moves a forbidden line-end character to the next line" do
      # Break before glyph 6 leaves 「 as line 1's last glyph;
      # kinsoku pushes it to line 2.
      glyphs = "一二三四「五六七".each_char.map { |c| glyph(c) }
      lines = described_class.break(glyphs: glyphs, frame_width: 55)

      expect(lines.first.glyphs.last.codepoint).to eq("四".ord)
      expect(lines.last.glyphs.first.codepoint).to eq("「".ord)
    end

    it "breaks unspaced CJK runs per character at the frame width" do
      glyphs = "一二三四五六".each_char.map { |c| glyph(c) }
      lines = described_class.break(glyphs: glyphs, frame_width: 50)

      expect(lines.length).to eq(2)
      expect(lines.first.glyphs.map { |g| [g.codepoint].pack("U") }.join)
        .to eq("一二三四五")
    end

    it "leaves non-CJK runs untouched" do
      glyphs = "abcdefgh".each_char.map { |c| glyph(c) }
      lines = described_class.break(glyphs: glyphs, frame_width: 50)

      expect(lines.first.glyphs.length).to eq(6)
      expect(lines.last.glyphs.map { |g| g.codepoint.chr }.join)
        .to eq("gh")
    end
  end
end

RSpec.describe Idml::TextEngine::Justifier do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:font) { pdfrb_metrics(font_path) }

  it "stretches inter-word spaces under :justified" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("aa bb cc")
    line = Idml::TextEngine::Line.new(glyphs, shaper.measure(glyphs), 0)
    space_widths = glyphs.select(&:is_space).map(&:width)
    limits = described_class::SpacingLimits.new(
      max_word_spacing: 500, max_letter_spacing: 0,
    )

    described_class.justify(line: line, frame_width: line.width + 20,
                            alignment: :justified, limits: limits)
    stretched = line.glyphs.select(&:is_space).map(&:width)
    expect(stretched).to all(be > 0)
    expect(stretched.sum - space_widths.sum).to be > 15
  end

  it "caps word-space stretching at MaximumWordSpacing" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("aa bb")
    natural_space = glyphs.find(&:is_space).width
    line = Idml::TextEngine::Line.new(glyphs, shaper.measure(glyphs), 0)
    slack = 40.0
    limits = described_class::SpacingLimits.new(
      max_word_spacing: 120, max_letter_spacing: 0,
    )

    described_class.justify(line: line, frame_width: line.width + slack,
                            alignment: :justified, limits: limits)

    stretched = line.glyphs.find(&:is_space).width
    expect(stretched).to be <= natural_space * 1.201
    expect(line.glyphs.sum(&:width)).to be < line.width + slack
  end

  it "distributes residual slack as letter spacing when allowed" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("aa bb")
    line = Idml::TextEngine::Line.new(glyphs, shaper.measure(glyphs), 0)
    slack = 6.0
    limits = described_class::SpacingLimits.new(
      max_word_spacing: 100, max_letter_spacing: 100,
    )

    natural_widths = line.glyphs.map(&:width)
    natural_total = line.width

    described_class.justify(line: line, frame_width: line.width + slack,
                            alignment: :justified, limits: limits)

    # Word cap of 100% = no space growth; the whole slack is
    # letter-spaced uniformly across every glyph (tracking applies
    # to spaces too).
    per_glyph = slack / line.glyphs.length
    line.glyphs.each_with_index do |glyph, index|
      expect(glyph.width).to be_within(0.01)
        .of(natural_widths[index] + per_glyph)
    end
    expect(line.glyphs.sum(&:width)).to be_within(0.01)
      .of(natural_total + slack)
  end

  it "keeps the last line ragged under :justified" do
    shaper = Idml::TextEngine::Shaper.new(font, 12)
    glyphs = shaper.shape("aa bb cc")
    line = Idml::TextEngine::Line.new(glyphs, shaper.measure(glyphs), 0)
    total = line.width

    described_class.justify(line: line, frame_width: total + 20,
                            alignment: :justified, last_line: true)
    expect(line.x_offset).to eq(0)
    expect(line.glyphs.select(&:is_space).sum(&:width))
      .to be < total + 20
  end

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
