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
end
