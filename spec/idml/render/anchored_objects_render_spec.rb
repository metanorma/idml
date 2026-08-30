# frozen_string_literal: true

require "spec_helper"

# End-to-end: a synthetic package whose story embeds an anchored
# Rectangle (Story > PSR > CSR > Rectangle) renders the item via the
# standard page-item dispatch at its stored geometry.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def graphic_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Graphic xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Color Self="Color/Red" Model="Process" Space="RGB" ColorValue="255 0 0" Name="Red"/>
      </idPkg:Graphic>
    XML
  end

  def anchored_rect_xml(anchor_position)
    <<~XML
      <Rectangle Self="rect1" ItemTransform="1 0 0 1 100 100" FillColor="Color/Red">
        <AnchoredObjectSetting AnchoredPosition="#{anchor_position}" AnchorPoint="TopLeftAnchor" AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0"/>
        <Properties>
          <PathGeometry>
            <GeometryPathType PathOpen="false">
              <PathPointArray>
                <PathPointType Anchor="0 0" LeftDirection="0 0" RightDirection="0 0"/>
                <PathPointType Anchor="0 50" LeftDirection="0 50" RightDirection="0 50"/>
                <PathPointType Anchor="80 50" LeftDirection="80 50" RightDirection="80 50"/>
                <PathPointType Anchor="80 0" LeftDirection="80 0" RightDirection="80 0"/>
              </PathPointArray>
            </GeometryPathType>
          </PathGeometry>
        </Properties>
      </Rectangle>
    XML
  end

  def story_xml(embedded_xml)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>Body text.</Content>
              #{embedded_xml}
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def anchored_fixture(story_markup)
    build_package(
      {
        "Stories/Story_u1.xml" => story_xml(story_markup),
        "Resources/Graphic.xml" => graphic_xml,
      },
      "anchored",
    )
  end

  def build_render_context(writer, package)
    font_resource = writer.register_font(font_path)
    metrics = Idml::TextEngine::PdfrbFontMetrics.new(
      writer.document.fonts, font_resource
    )
    frame = Idml::Elements::TextFrame.from_xml(
      '<TextFrame Self="tf1" ParentStory="u1"/>',
    )
    Idml::Render::RenderContext.new(
      item: frame,
      package: package,
      font_metrics: metrics,
      font_ps_name: font_resource,
      color_resolver: Idml::Render::ColorResolver.new(package.graphic),
      page_height: 400,
    )
  end

  def render_story_to_raw(package)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, build_render_context(writer, package))

    write_to_temp_pdf(writer, "anchored-e2e") do |pdf_path|
      yield File.binread(pdf_path)
    end
  end

  def rect_fill_count(raw)
    raw.scan(/\d re\b/).length
  end

  %w[InlinePosition AboveLine Anchored].each do |anchor_position|
    it "renders an anchored Rectangle for #{anchor_position}" do
      render_story_to_raw(anchored_fixture(anchored_rect_xml(anchor_position))) do |raw|
        expect(rect_fill_count(raw)).to be >= 1
        expect(raw).to match(/f\b/)
      end
    end
  end

  it "renders nothing extra when the story has no embedded items" do
    render_story_to_raw(anchored_fixture("")) do |raw|
      expect(rect_fill_count(raw)).to eq(0)
    end
  end
end
