# frozen_string_literal: true

require "spec_helper"

# End-to-end: a synthetic package whose story declares paragraph
# shading and border renders the shading rect behind the text and
# the border strokes around the paragraph block.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def story_xml(psr_attrs)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange #{psr_attrs}>
            <CharacterStyleRange PointSize="12">
              <Content>Decorated callout text.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def build_package(markup)
    dir = Dir.mktmpdir
    path = File.join(dir, "decorated.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => markup,
      },
      to: path,
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
      page_height: 400,
    )
  end

  def render_to_raw(package)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, build_render_context(writer, package))

    write_to_temp_pdf(writer, "decoration-e2e") do |pdf_path|
      yield File.binread(pdf_path)
    end
  end

  it "renders shading behind the paragraph text" do
    markup = story_xml('ParagraphShadingOn="true" ParagraphShadingTint="100"')
    render_to_raw(build_package(markup)) do |raw|
      expect(raw).to match(/\d re\b/)
      expect(raw).to match(/ f\b/)
    end
  end

  it "renders border strokes around the paragraph" do
    markup = story_xml(
      'ParagraphBorderOn="true" ParagraphBorderTopLineWeight="1" ' \
      'ParagraphBorderBottomLineWeight="1" ' \
      'ParagraphBorderLeftLineWeight="1" ParagraphBorderRightLineWeight="1"',
    )
    render_to_raw(build_package(markup)) do |raw|
      expect(raw.scan(" l\nS\n").length).to eq(4)
    end
  end

  it "renders no decoration when the PSR declares none" do
    render_to_raw(build_package(story_xml(""))) do |raw|
      expect(raw).not_to match(/\d re\b/)
      expect(raw.scan(" l\nS\n").length).to eq(0)
    end
  end
end
