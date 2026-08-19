# frozen_string_literal: true

require "spec_helper"

# StartParagraph forced breaks (TODO 120) and per-side cell edge
# strokes (TODO 121), verified end-to-end through synthetic
# packages / tables.
BREAK_FONT_CANDIDATES = [
  "/System/Library/Fonts/Supplemental/Arial.ttf",
  "/System/Library/Fonts/Helvetica.ttc",
  "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
  "C:/Windows/Fonts/arial.ttf",
].freeze

BreakStrokeColorResolver = Struct.new(:table, keyword_init: true) do
  def resolve(name)
    table[name]
  end
end

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    BREAK_FONT_CANDIDATES.find { |p| File.exist?(p) }
  end

  describe "StartParagraph breaks" do
    def story_xml(second_psr_attrs)
      <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
          <Story Self="u1">
            <ParagraphStyleRange>
              <CharacterStyleRange PointSize="12">
                <Content>First paragraph stays.</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
            <ParagraphStyleRange #{second_psr_attrs}>
              <CharacterStyleRange PointSize="12">
                <Content>Second paragraph breaks.</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
          </Story>
        </idPkg:Story>
      XML
    end

    def break_render_context(package, writer)
      font_resource = writer.register_font(font_path)
      metrics = Idml::TextEngine::PdfrbFontMetrics.new(
        writer.document.fonts, font_resource
      )
      frame = Idml::Elements::TextFrame.from_xml(
        '<TextFrame Self="tf1" ParentStory="u1"/>',
      )
      Idml::Render::RenderContext.new(
        item: frame, package: package, font_metrics: metrics,
        font_ps_name: font_resource, page_height: 400
      )
    end

    def break_package(second_psr_attrs)
      dir = Dir.mktmpdir
      path = File.join(dir, "break.idml")
      Idml::Package.write(
        parts: {
          "mimetype" => "application/vnd.adobe.indesign-idml-package",
          "Stories/Story_u1.xml" => story_xml(second_psr_attrs),
        },
        to: path,
      )
      Idml::Package.new(path)
    end

    def text_block_count(second_psr_attrs)
      skip "no system font available" unless font_path

      writer = Idml::Render::PdfrbWriter.new
      canvas = writer.add_page(width: 400, height: 400)
      described_class.render(
        canvas, break_render_context(break_package(second_psr_attrs),
                                     writer)
      )

      write_to_temp_pdf(writer, "start-paragraph") do |pdf_path|
        File.binread(pdf_path).scan(/BT\b/).length
      end
    end

    it "pushes a NextFrame paragraph to the next frame" do
      expect(text_block_count('StartParagraph="NextFrame"')).to eq(1)
    end

    it "renders both paragraphs without a declared break" do
      expect(text_block_count("")).to eq(2)
    end
  end

  describe "per-side cell edge strokes (TODO 121)" do
    let(:writer) { Idml::Render::PdfrbWriter.new }
    let(:canvas) { writer.add_page(width: 400, height: 400) }

    def table_xml(attrs, cell_attrs)
      <<~XML
        <Table Self="t1" ItemTransform="1 0 0 1 0 0" #{attrs}>
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                  <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                  <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                  <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <Row Self="r0" Name="0" SingleRowHeight="60"/>
          <Row Self="r1" Name="1" SingleRowHeight="60"/>
          <Cell Self="c00" Name="0:0" #{cell_attrs}/>
          <Cell Self="c10" Name="1:0" #{cell_attrs}/>
          <Cell Self="c01" Name="0:1" #{cell_attrs}/>
          <Cell Self="c11" Name="1:1" #{cell_attrs}/>
        </Table>
      XML
    end

    def stroke_context(table)
      Idml::Render::RenderContext.new(
        item: table,
        color_resolver: BreakStrokeColorResolver.new(
          table: { "Color/Red" => { model: :rgb, r: 1, g: 0, b: 0 } },
        ),
        page_height: 400,
      )
    end

    def render_cell_strokes(table_attrs, cell_attrs)
      table = Idml::Elements::Table.from_xml(
        table_xml(table_attrs, cell_attrs),
      )
      Idml::Render::Renderers::TableRenderer.render(
        canvas, stroke_context(table)
      )
      write_to_temp_pdf(writer, "cell-stroke") do |pdf_path|
        yield File.binread(pdf_path)
      end
    end

    it "draws one stroke per side when weights are declared" do
      render_cell_strokes(
        'DefaultRowStrokeWeight="0.5" DefaultColumnStrokeWeight="0.5"',
        "",
      ) do |raw|
        # 4 cells × 4 sides = 16 stroked lines.
        expect(raw.scan(" l\nS\n").length).to eq(16)
        expect(raw.scan(/\n0.5 w\n/).length).to be >= 16
      end
    end

    it "skips zero-weight sides" do
      render_cell_strokes(
        'DefaultRowStrokeWeight="0.5"',
        'TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0" ' \
        'LeftEdgeStrokeWeight="0" RightEdgeStrokeWeight="0"',
      ) do |raw|
        # All sides zero-weight via cell overrides: no side strokes.
        expect(raw.scan(" l\nS\n").length).to eq(0)
      end
    end

    it "keeps the legacy uniform border when nothing is declared" do
      render_cell_strokes("", "") do |raw|
        expect(raw.scan(/ re\b/).length).to eq(4)
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
