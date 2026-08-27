# frozen_string_literal: true

require "spec_helper"

# FirstBaselineOffset (TODO 128): the first line's baseline sits
# ascent-below the top inset under AscentOffset, vs the default
# leading-based position.
FBO_FONT_CANDIDATES = [
  "/System/Library/Fonts/Supplemental/Arial.ttf",
  "/System/Library/Fonts/Helvetica.ttc",
  "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
  "C:/Windows/Fonts/arial.ttf",
].freeze

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  def font_path
    FBO_FONT_CANDIDATES.find { |p| File.exist?(p) }
  end

  def fbo_story_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>First line.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def fbo_frame_xml(offset)
    pref = offset ? %(<TextFramePreference FirstBaselineOffset="#{offset}"/>) : ""
    %(<TextFrame Self="tf1" ParentStory="u1">#{pref}</TextFrame>)
  end

  def fbo_package
    dir = Dir.mktmpdir
    path = File.join(dir, "fbo.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => fbo_story_xml,
      },
      to: path,
    )
    Idml::Package.new(path)
  end

  def fbo_context(writer, package, offset)
    font_resource = writer.register_font(font_path)
    metrics = Idml::TextEngine::PdfrbFontMetrics.new(
      writer.document.fonts, font_resource
    )
    frame = Idml::Elements::TextFrame.from_xml(fbo_frame_xml(offset))
    Idml::Render::RenderContext.new(
      item: frame, package: package, font_metrics: metrics,
      font_ps_name: font_resource, page_height: 400
    )
  end

  def first_baseline_y(offset)
    skip "no system font available" unless font_path

    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(
      canvas, fbo_context(writer, fbo_package, offset)
    )

    text_ys(writer).max
  end

  def text_ys(writer)
    ys = []
    write_to_temp_pdf(writer, "first-baseline") do |pdf_path|
      ys = File.binread(pdf_path)
        .scan(/1 0 0 1 (-?\d+(?:\.\d+)?) (-?\d+(?:\.\d+)?) Tm\n/)
        .map { |_x, yy| yy.to_f }
    end
    ys
  end

  it "raises the first baseline under AscentOffset" do
    default_y = first_baseline_y(nil)
    ascent_y = first_baseline_y("AscentOffset")
    expect(ascent_y).to be > default_y
  end

  it "leaves the default leading-based baseline when unset" do
    expect(first_baseline_y(nil)).to be_within(0.01)
      .of(first_baseline_y("LeadingOffset"))
  end

  it "raises the first baseline under CapHeight (0.72 em fallback)" do
    default_y = first_baseline_y(nil)
    cap_y = first_baseline_y("CapHeight")
    # cap (0.72 em) < leading (1.2 em) → target below leading →
    # offset = target - leading is negative → baseline higher.
    expect(cap_y).to be > default_y
  end

  it "raises the first baseline further under XHeight than CapHeight" do
    x_y = first_baseline_y("XHeight")
    cap_y = first_baseline_y("CapHeight")
    expect(x_y).to be > cap_y
  end

  it "uses the em box (point size) under EmboxHeight" do
    default_y = first_baseline_y(nil)
    embox_y = first_baseline_y("EmboxHeight")
    # em (1.0 em) is below leading (1.2 em) but above cap height
    # (0.72 em): higher than default, lower than CapHeight.
    expect(embox_y).to be > default_y
    expect(embox_y).to be < first_baseline_y("CapHeight")
  end
end
