# frozen_string_literal: true

require "spec_helper"

# Lightweight metrics stub: every glyph 500/1000 ems. Real
# PdfrbFontMetrics needs a registered font file; the footnote
# layout only measures advances.
FootnoteFakeMetrics = Struct.new(:upem, keyword_init: true) do
  def units_per_em
    upem
  end

  def glyph_width(_codepoint)
    500
  end
end

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Footnote do
  let(:metrics) { FootnoteFakeMetrics.new(upem: 1000) }
  let(:frame) do
    Idml::TextEngine::Frame.new(x: 0, y: 0, width: 200, height: 400)
  end

  def footnote_story(markup)
    Idml::Parts::Story.from_xml(<<~XML)
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          #{markup}
        </Story>
      </idPkg:Story>
    XML
  end

  describe "::Counter" do
    it "numbers sequentially from 1 by default" do
      counter = described_class::Counter.new
      expect(counter.next_number).to eq(1)
      expect(counter.next_number).to eq(2)
      expect(counter.next_number).to eq(3)
    end

    it "honors StartAt" do
      counter = described_class::Counter.new(5)
      expect(counter.next_number).to eq(5)
      expect(counter.next_number).to eq(6)
    end
  end

  describe ".marker_text" do
    it "is the bare number without an option" do
      expect(described_class.marker_text(3, nil)).to eq("3")
    end

    it "wraps the number with Prefix/Suffix" do
      option = Idml::Elements::FootnoteOption.new(prefix: "n", suffix: ".")
      expect(described_class.marker_text(3, option)).to eq("n3.")
    end
  end

  describe ".marker_run" do
    it "inherits base styling and marks itself superscript" do
      base = Idml::Render::StyleResolver::StyledRun.new(
        text: "Body.", point_size: 12.0, font_style: "Bold",
      )
      paragraphs = [Idml::Render::StyleResolver::Paragraph.new(runs: [])]
      marker = described_class.marker_run(2, base, paragraphs, nil)

      expect(marker.text).to eq("2")
      expect(marker.position).to eq("Superscript")
      expect(marker.point_size).to eq(12.0)
      expect(marker.font_style).to eq("Bold")
      expect(marker.footnote_number).to eq(2)
      expect(marker.footnote_paragraphs).to eq(paragraphs)
    end

    it "falls back to defaults when the CSR has no text run" do
      marker = described_class.marker_run(1, nil, [], nil)
      expect(marker.text).to eq("1")
      expect(marker.point_size).to eq(Idml::Render::StyleResolver::DEFAULT_POINT_SIZE)
    end

    it "does not mutate the base run" do
      base = Idml::Render::StyleResolver::StyledRun.new(text: "Body.")
      described_class.marker_run(1, base, [], nil)
      expect(base.text).to eq("Body.")
      expect(base.position).to be_nil
    end
  end

  describe ".extract" do
    it "prefixes the marker to the footnote's first run" do
      element = Idml::Elements::Footnote.from_xml(<<~XML)
        <Footnote>
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="9">
              <Content>Note text.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Footnote>
      XML
      paragraphs = described_class.extract(element, 4)
      expect(paragraphs.first.runs.first.text).to eq("4 Note text.")
    end

    it "applies the option's Prefix/Suffix to the marker" do
      element = Idml::Elements::Footnote.from_xml(<<~XML)
        <Footnote>
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="9">
              <Content>Note.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Footnote>
      XML
      option = Idml::Elements::FootnoteOption.new(prefix: "n", suffix: ".")
      paragraphs = described_class.extract(element, 2, option: option)
      expect(paragraphs.first.runs.first.text).to eq("n2. Note.")
    end
  end

  describe "StyleResolver integration" do
    it "emits a numbered superscript marker run after the CSR text" do
      story = footnote_story(<<~XML)
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="12">
            <Content>Body text.</Content>
            <Footnote>
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="9">
                  <Content>Footnote text.</Content>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Footnote>
          </CharacterStyleRange>
        </ParagraphStyleRange>
      XML
      runs = Idml::Render::StyleResolver.extract_paragraphs(story).first.runs
      expect(runs.length).to eq(2)
      expect(runs.first.text).to eq("Body text.")
      expect(runs.last.text).to eq("1")
      expect(runs.last.position).to eq("Superscript")
      expect(runs.last.footnote_number).to eq(1)
      expect(runs.last.footnote_paragraphs.first.runs.first.text)
        .to eq("1 Footnote text.")
    end

    it "numbers footnotes sequentially across paragraphs" do
      story = footnote_story(<<~XML)
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="12">
            <Content>First.</Content>
            <Footnote>
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="9"><Content>One.</Content></CharacterStyleRange>
              </ParagraphStyleRange>
            </Footnote>
          </CharacterStyleRange>
        </ParagraphStyleRange>
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="12">
            <Content>Second.</Content>
            <Footnote>
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="9"><Content>Two.</Content></CharacterStyleRange>
              </ParagraphStyleRange>
            </Footnote>
          </CharacterStyleRange>
        </ParagraphStyleRange>
      XML
      paragraphs = Idml::Render::StyleResolver.extract_paragraphs(story)
      expect(paragraphs[0].runs.last.footnote_number).to eq(1)
      expect(paragraphs[1].runs.last.footnote_number).to eq(2)
    end

    it "emits a marker for a CSR that holds only a footnote" do
      story = footnote_story(<<~XML)
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="12">
            <Footnote>
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="9"><Content>Only note.</Content></CharacterStyleRange>
              </ParagraphStyleRange>
            </Footnote>
          </CharacterStyleRange>
        </ParagraphStyleRange>
      XML
      runs = Idml::Render::StyleResolver.extract_paragraphs(story).first.runs
      expect(runs.length).to eq(1)
      expect(runs.first.text).to eq("1")
    end

    it "honors FootnoteOption StartAt via the extraction kwarg" do
      story = footnote_story(<<~XML)
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="12">
            <Content>Body.</Content>
            <Footnote>
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="9"><Content>Note.</Content></CharacterStyleRange>
              </ParagraphStyleRange>
            </Footnote>
          </CharacterStyleRange>
        </ParagraphStyleRange>
      XML
      option = Idml::Elements::FootnoteOption.new(start_at: 7)
      runs = Idml::Render::StyleResolver.extract_paragraphs(
        story, footnote_option: option
      ).first.runs
      expect(runs.last.text).to eq("7")
    end
  end

  describe ".reserved_height" do
    it "is zero with no entries" do
      expect(described_class.reserved_height([], metrics, frame)).to eq(0.0)
    end

    it "covers the separator gap plus the measured paragraphs" do
      entry = described_class::Entry.new(
        number: 1,
        paragraphs: [Idml::Render::StyleResolver::Paragraph.new(
          runs: [Idml::Render::StyleResolver::StyledRun.new(
            text: "Note.", point_size: 10.0,
          )],
        )],
      )
      height = described_class.reserved_height([entry], metrics, frame)
      expect(height).to be > described_class::DEFAULT_RULE_GAP
    end
  end

  describe ".layout_entries" do
    it "positions lines below the start cursor, descending" do
      entry = described_class::Entry.new(
        number: 1,
        paragraphs: [Idml::Render::StyleResolver::Paragraph.new(
          runs: [Idml::Render::StyleResolver::StyledRun.new(
            text: "Note.", point_size: 10.0,
          )],
        )],
      )
      positioned, bottom_y = described_class.layout_entries(
        [entry], frame, metrics, 100.0
      )
      expect(positioned).not_to be_empty
      expect(positioned.first.line.y).to be < 100.0
      expect(bottom_y).to be <= positioned.first.line.y
    end
  end

  describe ".emit_separator" do
    let(:writer) { Idml::Render::PdfrbWriter.new }
    let(:canvas) { writer.add_page(width: 400, height: 400) }

    it "draws a rule with the default weight" do
      described_class.emit_separator(canvas, frame, 50.0, nil)
      write_to_temp_pdf(writer, "fn-separator") do |path|
        expect(File.binread(path)).to include("0.5 w")
      end
    end

    it "draws nothing when RuleOn is false" do
      option = Idml::Elements::FootnoteOption.new(rule_on: false)
      described_class.emit_separator(canvas, frame, 50.0, option)
      write_to_temp_pdf(writer, "fn-separator-off") do |path|
        expect(File.binread(path)).not_to include("0.5 w")
      end
    end

    it "honors RuleLineWeight" do
      option = Idml::Elements::FootnoteOption.new(rule_line_weight: 2)
      described_class.emit_separator(canvas, frame, 50.0, option)
      write_to_temp_pdf(writer, "fn-separator-weight") do |path|
        expect(File.binread(path)).to include("2 w")
      end
    end
  end

  describe ".option" do
    it "returns nil for a nil package" do
      expect(described_class.option(nil)).to be_nil
    end
  end
end
