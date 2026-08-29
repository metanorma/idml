# frozen_string_literal: true

require "spec_helper"

# End-to-end: a synthetic package with a footnoted story renders the
# footnote area (separator rule + footnote text block) at the frame
# bottom via TextFrameRenderer's engine path.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def footnote_story_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>Body text with a footnote.</Content>
              <Footnote>
                <ParagraphStyleRange>
                  <CharacterStyleRange PointSize="9">
                    <Content>The footnote remark.</Content>
                  </CharacterStyleRange>
                </ParagraphStyleRange>
              </Footnote>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def preferences_xml(rule_on: true)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Preferences xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <FootnoteOption StartAt="1" Prefix="" Suffix="" RuleOn="#{rule_on}" RuleLineWeight="1" RuleWidth="72"/>
      </idPkg:Preferences>
    XML
  end

  def build_package(story_xml, prefs_xml)
    dir = Dir.mktmpdir
    path = File.join(dir, "footnote.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => story_xml,
        "Resources/Preferences.xml" => prefs_xml,
      },
      to: path,
    )
  end

  def build_context(writer, package)
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

  def render_footnoted_frame(writer, package)
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, build_context(writer, package))
  end

  def render_to_raw(story_xml, prefs_xml)
    skip "no system font available" unless font_path

    package = build_package(story_xml, prefs_xml)
    writer = Idml::Render::PdfrbWriter.new
    render_footnoted_frame(writer, package)

    write_to_temp_pdf(writer, "fn-e2e") do |pdf_path|
      yield File.binread(pdf_path)
    end
  end

  def bt_count(raw)
    raw.scan(/BT\b/).length
  end

  it "renders the separator rule and an extra text block for the footnote" do
    body_only = footnote_story_xml.gsub(
      %r{<Footnote>.*</Footnote>}m,
      "",
    )
    render_to_raw(body_only, preferences_xml) do |raw_without|
      render_to_raw(footnote_story_xml, preferences_xml) do |raw_with|
        expect(raw_with).to include("1 w")
        expect(raw_with).to match(/S\b| S/)
        expect(bt_count(raw_with)).to be > bt_count(raw_without)
      end
    end
  end

  it "omits the separator when RuleOn is false" do
    render_to_raw(footnote_story_xml, preferences_xml(rule_on: false)) do |raw|
      expect(raw).not_to include("1 w")
    end
  end
end
