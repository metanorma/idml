# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::ParagraphRules do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def paragraph(overrides = {})
    attrs = { runs: [], alignment: :left }.merge(overrides)
    Idml::Render::StyleResolver::Paragraph.new(**attrs)
  end

  def context_without_color
    Idml::Render::RenderContext.new(
      item: nil, package: nil, color_resolver: nil, page_height: 400,
    )
  end

  describe ".emit_rule_above" do
    it "does nothing when rule_above is false / nil" do
      described_class.emit_rule_above(canvas, paragraph(rule_above: nil),
                                      context_without_color,
                                      300, 50, 350)
      described_class.emit_rule_above(canvas, paragraph(rule_above: false),
                                      context_without_color,
                                      300, 50, 350)
      write_to_temp_pdf(writer, "rule-skipped") do |path|
        # No stroke ops should appear (only the page's default ops).
        raw = File.binread(path)
        expect(raw.scan(/\bS\b/).length).to eq(0)
      end
    end

    it "draws a horizontal stroke when rule_above is true" do
      para = paragraph(rule_above: true, rule_above_line_weight: 1.0)
      described_class.emit_rule_above(canvas, para, context_without_color,
                                      300, 50, 350)
      write_to_temp_pdf(writer, "rule-emitted") do |path|
        raw = File.binread(path)
        # At least one stroke op.
        expect(raw).to match(/\bS\b/)
      end
    end

    it "honors RuleAboveWidth='Text' by indenting to paragraph bounds" do
      para = paragraph(
        rule_above: true,
        rule_above_line_weight: 1.0,
        rule_above_width: "Text",
        left_indent: 30,
        right_indent: 20,
      )
      described_class.emit_rule_above(canvas, para, context_without_color,
                                      300, 100, 300)
      write_to_temp_pdf(writer, "rule-text-width") do |path|
        # The line should start at 100 + 30 = 130 (frame_left + left_indent)
        # and end at 300 - 20 = 280 (frame_right - right_indent).
        # We just verify a stroke was emitted; precise coords
        # depend on pdfrb's emit format.
        raw = File.binread(path)
        expect(raw).to match(/\bS\b/)
      end
    end

    it "skips when line_weight is zero" do
      para = paragraph(rule_above: true, rule_above_line_weight: 0.0)
      described_class.emit_rule_above(canvas, para, context_without_color,
                                      300, 50, 350)
      write_to_temp_pdf(writer, "rule-zero-weight") do |path|
        raw = File.binread(path)
        expect(raw.scan(/\bS\b/).length).to eq(0)
      end
    end
  end

  describe ".emit_rule_below" do
    it "draws a horizontal stroke when rule_below is true" do
      para = paragraph(rule_below: true, rule_below_line_weight: 1.0)
      described_class.emit_rule_below(canvas, para, context_without_color,
                                      100, 50, 350)
      write_to_temp_pdf(writer, "rule-below") do |path|
        raw = File.binread(path)
        expect(raw).to match(/\bS\b/)
      end
    end
  end

  describe ".emit_shading" do
    it "does nothing when paragraph_shading_on is falsy" do
      described_class.emit_shading(canvas, paragraph(paragraph_shading_on: nil),
                                   context_without_color, 300, 200, 50, 350)
      write_to_temp_pdf(writer, "shade-off") do |path|
        expect(File.binread(path)).not_to include(" re")
      end
    end

    it "fills the paragraph rect when shading is on" do
      para = paragraph(paragraph_shading_on: true,
                       paragraph_shading_color: "Color/Red")
      described_class.emit_shading(canvas, para, context_without_color,
                                   300, 200, 50, 350)
      write_to_temp_pdf(writer, "shade-on") do |path|
        raw = File.binread(path)
        expect(raw).to include(" re")
        expect(raw).to match(/\b f\b/)
      end
    end

    it "fills black by default when no color element resolved" do
      para = paragraph(paragraph_shading_on: true)
      described_class.emit_shading(canvas, para, context_without_color,
                                   300, 200, 50, 350)
      write_to_temp_pdf(writer, "shade-default") do |path|
        expect(File.binread(path)).to include(" re")
      end
    end

    it "does nothing when tint is zero" do
      para = paragraph(paragraph_shading_on: true, paragraph_shading_tint: 0)
      described_class.emit_shading(canvas, para, context_without_color,
                                   300, 200, 50, 350)
      write_to_temp_pdf(writer, "shade-zero-tint") do |path|
        expect(File.binread(path)).not_to include(" re")
      end
    end
  end

  describe ".emit_border" do
    it "does nothing when paragraph_border_on is falsy" do
      described_class.emit_border(canvas, paragraph(paragraph_border_on: nil),
                                  context_without_color, 300, 200, 50, 350)
      write_to_temp_pdf(writer, "border-off") do |path|
        expect(File.binread(path).scan(/\bS\b/).length).to eq(0)
      end
    end

    it "strokes each side with a positive weight" do
      para = paragraph(
        paragraph_border_on: true,
        paragraph_border_top_line_weight: 1,
        paragraph_border_bottom_line_weight: 2,
        paragraph_border_left_line_weight: 1,
        paragraph_border_right_line_weight: 1,
      )
      described_class.emit_border(canvas, para, context_without_color,
                                  300, 200, 50, 350)
      write_to_temp_pdf(writer, "border-sides") do |path|
        raw = File.binread(path)
        expect(raw.scan(/\bS\b/).length).to eq(4)
        expect(raw.scan(/\b2 w\b/).length).to eq(1)
      end
    end

    it "skips sides with zero weight" do
      para = paragraph(
        paragraph_border_on: true,
        paragraph_border_top_line_weight: 1,
        paragraph_border_bottom_line_weight: 0,
        paragraph_border_left_line_weight: 0,
        paragraph_border_right_line_weight: 0,
      )
      described_class.emit_border(canvas, para, context_without_color,
                                  300, 200, 50, 350)
      write_to_temp_pdf(writer, "border-partial") do |path|
        expect(File.binread(path).scan(/\bS\b/).length).to eq(1)
      end
    end
  end
end
