# frozen_string_literal: true

require "spec_helper"

# Simple-render (no FontMetrics) footnote path (TODO 137): the
# rough fallback emits footnote paragraphs stacked at the frame
# bottom below a hairline separator, instead of dropping the
# footnote text entirely.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def story_xml(footnote: true)
    footnote_xml = footnote ? <<~XML : ""
      <Footnote>
        <ParagraphStyleRange>
          <CharacterStyleRange PointSize="9">
            <Content>The footnote remark.</Content>
          </CharacterStyleRange>
        </ParagraphStyleRange>
      </Footnote>
    XML
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>Body text.</Content>
              #{footnote_xml}
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def build_package(xml)
    dir = Dir.mktmpdir
    path = File.join(dir, "simple-footnote.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => xml,
      },
      to: path,
    )
    Idml::Package.new(path)
  end

  def build_context(package)
    font_resource = font_path && Idml::Render::PdfrbWriter.new
      .register_font(font_path)
    frame = Idml::Elements::TextFrame.from_xml(
      '<TextFrame Self="tf1" ParentStory="u1"/>',
    )
    Idml::Render::RenderContext.new(
      item: frame,
      package: package,
      # No font_metrics → the simple_render path.
      font_ps_name: font_resource,
      page_height: 400,
    )
  end

  def render_raw(xml)
    package = build_package(xml)
    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, build_context(package))
    write_to_temp_pdf(writer, "simple-fn") do |path|
      yield File.binread(path)
    end
  end

  it "emits the footnote text below the body block in the simple path" do
    skip "no system font available" unless font_path

    render_raw(story_xml(footnote: false)) do |raw_without|
      render_raw(story_xml(footnote: true)) do |raw_with|
        # Body block + one footnote paragraph block.
        expect(PdfStream.bt_count(raw_with)).to eq(PdfStream.bt_count(raw_without) + 1)
        # Hairline separator rule.
        expect(raw_with).to include("0.5 w")
      end
    end
  end

  it "adds no footnote block when the story has no footnotes" do
    skip "no system font available" unless font_path

    render_raw(story_xml(footnote: false)) do |raw|
      expect(raw).not_to include("0.5 w")
    end
  end
end
