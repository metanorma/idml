# frozen_string_literal: true

require "spec_helper"

# Vertical multi-run column continuity (regression: every run used
# to restart at column 0, overlapping) and tate-chu-yoko, verified
# end-to-end through synthetic packages.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    spec_font_path
  end

  def vertical_story_xml(csrs)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <StoryPreference StoryOrientation="Vertical"/>
          <ParagraphStyleRange>
            #{csrs}
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def vertical2_package(csrs)
    build_package({
                    "mimetype" => "application/vnd.adobe.indesign-idml-package",
                    "Stories/Story_u1.xml" => vertical_story_xml(csrs),
                  },
                  "vertical2")
  end

  def vertical2_context(writer, package)
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

  def render_vertical_raw(csrs)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(
      canvas, vertical2_context(writer, vertical2_package(csrs))
    )

    raw = ""
    write_to_temp_pdf(writer, "vertical2") do |pdf_path|
      raw = File.binread(pdf_path)
    end
    raw
  end

  # Text matrix ops (1 0 0 1 x y Tm) per text block.

  it "places the second run's column to the left of the first" do
    csrs = <<~XML
      <CharacterStyleRange PointSize="12"><Content>日</Content></CharacterStyleRange>
      <CharacterStyleRange PointSize="12"><Content>本</Content></CharacterStyleRange>
    XML
    raw = render_vertical_raw(csrs)
    xs = PdfStream.text_positions(raw).map(&:first).uniq.sort.reverse

    expect(xs.length).to eq(2)
    expect(xs[1]).to be < xs[0]
  end

  describe "tate-chu-yoko" do
    it "renders digit groups horizontally sharing one baseline" do
      csrs = <<~XML
        <CharacterStyleRange PointSize="12" Tatechuyoko="true"><Content>12</Content></CharacterStyleRange>
      XML
      raw = render_vertical_raw(csrs)

      positions = PdfStream.text_positions(raw)
      expect(positions.length).to eq(2)
      expect(positions[0][1]).to eq(positions[1][1])
      expect(positions[1][0]).to be > positions[0][0]
      expect(raw.scan("0 -1 1 0").length).to eq(0)
    end

    it "keeps the rotated stacked path when Tatechuyoko is not declared" do
      csrs = <<~XML
        <CharacterStyleRange PointSize="12"><Content>12</Content></CharacterStyleRange>
      XML
      raw = render_vertical_raw(csrs)

      # Latin digits without Tatechuyoko go through the rotated
      # path — run-grouped, so the consecutive digits share one
      # rotation matrix.
      expect(raw.scan("0 -1 1 0").length).to eq(1)
    end
  end
end
