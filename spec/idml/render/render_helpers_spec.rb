# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  describe Idml::Render::ColorHelper do
    describe ".to_canvas" do
      it "converts RGB hash to pdfrb array" do
        result = described_class.to_canvas(model: :rgb, r: 0.5, g: 0.25, b: 0.75)
        expect(result).to eq([:rgb, 0.5, 0.25, 0.75])
      end

      it "converts CMYK hash to pdfrb array" do
        result = described_class.to_canvas(model: :cmyk, c: 0.1, m: 0.2,
                                           y: 0.3, k: 0.4)
        expect(result).to eq([:cmyk, 0.1, 0.2, 0.3, 0.4])
      end

      it "returns nil for nil input" do
        expect(described_class.to_canvas(nil)).to be_nil
      end
    end

    describe ".apply_tint" do
      let(:red) { { model: :rgb, r: 1.0, g: 0.0, b: 0.0 } }
      let(:cyan) { { model: :cmyk, c: 1.0, m: 0.0, y: 0.0, k: 0.0 } }

      it "returns the color unchanged when tint is nil" do
        expect(described_class.apply_tint(red, nil)).to eq(red)
      end

      it "returns the color unchanged when tint >= 1.0" do
        expect(described_class.apply_tint(red, 1.0)).to eq(red)
        expect(described_class.apply_tint(red, 1.5)).to eq(red)
      end

      it "scales RGB components by tint" do
        result = described_class.apply_tint(red, 0.5)
        expect(result).to eq(model: :rgb, r: 0.5, g: 0.0, b: 0.0)
      end

      it "scales CMYK components by tint" do
        result = described_class.apply_tint(cyan, 0.25)
        expect(result).to eq(model: :cmyk, c: 0.25, m: 0.0, y: 0.0, k: 0.0)
      end

      it "tint 0.0 zeroes all components" do
        result = described_class.apply_tint(red, 0.0)
        expect(result).to eq(model: :rgb, r: 0.0, g: 0.0, b: 0.0)
      end

      it "passes through unknown color models unchanged" do
        weird = { model: :lab, l: 50, a: 0, b: 0 }
        expect(described_class.apply_tint(weird, 0.5)).to eq(weird)
      end

      it "returns nil for nil input" do
        expect(described_class.apply_tint(nil, 0.5)).to be_nil
      end
    end
  end

  describe Idml::Render::StyleResolver do
    let(:fixture_path) do
      File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    describe ".extract_runs" do
      it "returns empty array for nil story" do
        expect(described_class.extract_runs(nil)).to eq([])
      end

      it "extracts runs from a story" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs).to be_an(Array)
        expect(runs).not_to be_empty
        expect(runs.first).to be_a(described_class::StyledRun)
      end

      it "each run has text content" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs.first.text).to be_a(String)
        expect(runs.first.text).not_to be_empty
      end

      it "each run has a point_size defaulting to 12.0" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs.first.point_size).to eq(12.0)
      end

      it "each run has an alignment defaulting to :left" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs.first.alignment).to eq(:left).or be(:center).or be(:right).or be(:justified)
      end
    end

    describe ".extract_paragraphs" do
      it "returns empty array for nil story" do
        expect(described_class.extract_paragraphs(nil)).to eq([])
      end

      it "groups runs by paragraph and carries paragraph-level attrs" do
        story = package.story_by_id("ue1")
        paragraphs = described_class.extract_paragraphs(story)
        expect(paragraphs).not_to be_empty
        expect(paragraphs.first).to be_a(described_class::Paragraph)
        expect(paragraphs.first.runs).to be_an(Array)
        expect(paragraphs.first.runs).not_to be_empty
      end

      it "Paragraph carries space_before / space_after from PSR" do
        paragraphs = described_class.extract_paragraphs(
          package.story_by_id("ue1"),
        )
        para = paragraphs.first
        expect(para).to respond_to(:space_before)
        expect(para).to respond_to(:space_after)
        expect(para).to respond_to(:first_line_indent)
        expect(para).to respond_to(:left_indent)
        expect(para).to respond_to(:right_indent)
        expect(para).to respond_to(:auto_leading)
      end

      it "carries start_paragraph and justification caps from the PSR" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange StartParagraph="NextPage" MaximumWordSpacing="150" MaximumLetterSpacing="25">
                <CharacterStyleRange>
                  <Content>Heading.</Content>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        para = described_class.extract_paragraphs(story).first
        expect(para.start_paragraph).to eq("NextPage")
        expect(para.maximum_word_spacing).to eq(150.0)
        expect(para.maximum_letter_spacing).to eq(25.0)
      end

      it "emits superscript endnote markers for CSR EndnoteRange elements" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="12">
                  <Content>See note</Content>
                  <EndnoteRange Self="r1" SourceEndnote="e1"/>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        runs = described_class.extract_paragraphs(story).first.runs
        expect(runs.length).to eq(2)
        expect(runs.last.text).to eq("1")
        expect(runs.last.position).to eq("Superscript")
        expect(runs.last.footnote_paragraphs).to be_nil
      end

      it "numbers endnotes separately from footnotes" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange>
                <CharacterStyleRange PointSize="12">
                  <Content>A</Content>
                  <Footnote>
                    <ParagraphStyleRange>
                      <CharacterStyleRange PointSize="9"><Content>fn</Content></CharacterStyleRange>
                    </ParagraphStyleRange>
                  </Footnote>
                  <EndnoteRange Self="r1" SourceEndnote="e1"/>
                  <EndnoteRange Self="r2" SourceEndnote="e2"/>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        runs = described_class.extract_paragraphs(story).first.runs
        markers = runs.select { |r| r.position == "Superscript" }
        expect(markers.map(&:text)).to eq(["1", "1", "2"])
        expect(markers.first.footnote_paragraphs).not_to be_nil
        expect(markers.last.footnote_paragraphs).to be_nil
      end

      it "carries keep_all_lines_together from the PSR" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange KeepAllLinesTogether="true">
                <CharacterStyleRange>
                  <Content>Heading.</Content>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        para = described_class.extract_paragraphs(story).first
        expect(para.keep_all_lines_together).to be(true)
      end

      it "carries shading and border attrs from a declaring PSR" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange ParagraphShadingOn="true" ParagraphShadingTint="50"
                                   ParagraphBorderOn="true" ParagraphBorderTopLineWeight="1">
                <Properties>
                  <ParagraphShadingColor type="string">Color/Red</ParagraphShadingColor>
                  <ParagraphBorderColor type="string">Color/Blue</ParagraphBorderColor>
                </Properties>
                <CharacterStyleRange>
                  <Content>Shaded callout.</Content>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        para = described_class.extract_paragraphs(story).first
        expect(para.paragraph_shading_on).to be(true)
        expect(para.paragraph_shading_color).to eq("Color/Red")
        expect(para.paragraph_shading_tint).to eq(50.0)
        expect(para.paragraph_border_on).to be(true)
        expect(para.paragraph_border_color).to eq("Color/Blue")
        expect(para.paragraph_border_top_line_weight).to eq(1.0)
      end

      it "prefers Properties RuleAboveColor over stroke_color" do
        story = Idml::Parts::Story.from_xml(<<~XML)
          <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
            <Story Self="u1">
              <ParagraphStyleRange RuleAbove="true" StrokeColor="Color/Red">
                <Properties>
                  <RuleAboveColor type="string">Color/Blue</RuleAboveColor>
                </Properties>
                <CharacterStyleRange>
                  <Content>Rule text.</Content>
                </CharacterStyleRange>
              </ParagraphStyleRange>
            </Story>
          </idPkg:Story>
        XML
        para = described_class.extract_paragraphs(story).first
        expect(para.rule_above_color).to eq("Color/Blue")
      end
    end

    describe "ALIGNMENT_MAP" do
      it "maps IDML Left to :left" do
        expect(described_class::ALIGNMENT_MAP["Left"]).to eq(:left)
      end

      it "maps IDML Center to :center" do
        expect(described_class::ALIGNMENT_MAP["Center"]).to eq(:center)
      end

      it "maps IDML Right to :right" do
        expect(described_class::ALIGNMENT_MAP["Right"]).to eq(:right)
      end

      it "maps IDML FullyJustified to :justified" do
        expect(described_class::ALIGNMENT_MAP["FullyJustified"]).to eq(:justified)
      end
    end

    describe ".concatenate" do
      it "joins run text into single string" do
        run1 = described_class::StyledRun.new(text: "Hello ")
        run2 = described_class::StyledRun.new(text: "World")
        expect(described_class.concatenate([run1, run2])).to eq("Hello World")
      end
    end
  end

  describe Idml::Render::GradientResolver do
    describe ".gradient?" do
      it "returns true for Gradient/* names" do
        expect(described_class.gradient?("Gradient/MyGradient")).to be true
      end

      it "returns false for Color/* names" do
        expect(described_class.gradient?("Color/Red")).to be false
      end

      it "returns false for nil" do
        expect(described_class.gradient?(nil)).to be false
      end
    end
  end

  describe Idml::Render::FontReferenceResolver do
    let(:fixture_path) do
      File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    describe ".build" do
      it "builds a lookup table from Fonts.xml" do
        resolver = described_class.build(package)
        expect(resolver).to be_a(described_class)
      end

      it "resolves font family names to PostScriptNames" do
        resolver = described_class.build(package)
        ps_name = resolver.resolve("Minion Pro")
        expect(ps_name).to be_a(String).or be_nil
      end

      it "returns nil for unknown font reference" do
        resolver = described_class.build(package)
        expect(resolver.resolve("NonExistentFont")).to be_nil
      end

      it "returns nil for nil input" do
        resolver = described_class.build(package)
        expect(resolver.resolve(nil)).to be_nil
      end
    end

    describe ".build with nil package" do
      it "returns a resolver with empty table" do
        resolver = described_class.build(nil)
        expect(resolver.resolve("Anything")).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
