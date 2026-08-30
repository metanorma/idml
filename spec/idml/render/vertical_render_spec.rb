# frozen_string_literal: true

require "spec_helper"

# Vertical writing mode (StoryOrientation="Vertical") end-to-end:
# glyphs render upright, one text op per glyph.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def story_xml(orientation, content = "日本語", ruby_attrs = "")
    preference = orientation ? %(<StoryPreference StoryOrientation="#{orientation}"/>) : ""
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          #{preference}
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12" #{ruby_attrs}>
              <Content>#{content}</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def vertical_raw(content, ruby: "")
    package = vertical_package("Vertical", content, ruby)
    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, vertical_context(writer, package))

    raw = ""
    write_to_temp_pdf(writer, "vertical-raw") do |pdf_path|
      raw = File.binread(pdf_path)
    end
    raw
  end

  def vertical_package(orientation, content = "日本語", ruby_attrs = "")
    build_package({
                    "mimetype" => "application/vnd.adobe.indesign-idml-package",
                    "Stories/Story_u1.xml" => story_xml(orientation, content,
                                                        ruby_attrs),
                  },
                  "vertical")
  end

  def vertical_context(writer, package)
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

  def text_op_count(orientation)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(
      canvas, vertical_context(writer, vertical_package(orientation))
    )

    write_to_temp_pdf(writer, "vertical-e2e") do |pdf_path|
      File.binread(pdf_path).scan("\nBT\n").length
    end
  end

  it "renders one text op per glyph in vertical mode" do
    expect(text_op_count("Vertical")).to eq(3)
  end

  it "keeps the horizontal single text op for the same content" do
    expect(text_op_count("Horizontal")).to eq(1)
  end

  it "rotates Latin runs as one group and keeps CJK upright" do
    skip "no system font available" unless font_path

    raw = vertical_raw("Ab")
    # Consecutive Latin glyphs share one rotated graphics state.
    expect(raw.scan("0 -1 1 0").length).to eq(1)

    # Latin groups separated by CJK rotate separately.
    mixed_raw = vertical_raw("A日B")
    expect(mixed_raw.scan("0 -1 1 0").length).to eq(2)

    cjk_raw = vertical_raw("日本")
    expect(cjk_raw.scan("0 -1 1 0").length).to eq(0)
  end

  it "renders a Latin group as a single text op in vertical mode" do
    skip "no system font available" unless font_path

    raw = vertical_raw("Ab")
    expect(raw.scan("\nBT\n").length).to eq(1)
  end

  it "emits vertical ruby beside the base glyphs" do
    skip "no system font available" unless font_path

    with_ruby = vertical_raw("漢", ruby: 'RubyString="かな"')
    without_ruby = vertical_raw("漢")
    expect(PdfStream.bt_count(with_ruby)).to eq(PdfStream.bt_count(without_ruby) + 2)
  end
end
