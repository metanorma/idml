# frozen_string_literal: true

require "spec_helper"

# End-of-story endnote TEXT rendering (TODO 117): the package's
# endnote stories (IsEndnoteStory) append after the main story's
# flow when the main story carries EndnoteRange markers.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def main_story_xml(with_marker:)
    marker = with_marker ? '<EndnoteRange Self="r1" SourceEndnote="e1"/>' : ""
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>Main text.</Content>
              #{marker}
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def endnote_story_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u2" IsEndnoteStory="true">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="9">
              <Content>The endnote remark.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def build_package(with_marker:)
    dir = Dir.mktmpdir
    path = File.join(dir, "endnote.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => main_story_xml(with_marker: with_marker),
        "Stories/Story_u2.xml" => endnote_story_xml,
      },
      to: path,
    )
    Idml::Package.new(path)
  end

  def endnote_context(writer, package)
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

  def text_block_count(package)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, endnote_context(writer, package))

    write_to_temp_pdf(writer, "endnote-text") do |pdf_path|
      File.binread(pdf_path).scan("\nBT\n").length
    end
  end

  it "appends endnote-story text after the marked main flow" do
    with_marker = text_block_count(build_package(with_marker: true))
    without_marker = text_block_count(build_package(with_marker: false))
    # With the marker: main text + marker + endnote text (3 blocks);
    # without: main text only (1) — the endnote story is ignored.
    expect(with_marker).to eq(3)
    expect(without_marker).to eq(1)
  end
end
