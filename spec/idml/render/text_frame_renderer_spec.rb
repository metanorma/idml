# frozen_string_literal: true

require "spec_helper"

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def first_text_frame
    spread = package.spreads.first.spread.first
    spread.each_page_item.find do |frame|
      frame.is_a?(Idml::Elements::TextFrame) &&
        (frame.previous_text_frame.nil? || frame.previous_text_frame == "n")
    end
  end

  def build_context(frame, font_ps_name: "Helvetica")
    Idml::Render::RenderContext.new(
      item: frame,
      package: package,
      color_resolver: Idml::Render::ColorResolver.new(package.graphic),
      font_ps_name: font_ps_name,
      page_height: 400,
    )
  end

  it "renders nothing when frame has no parent_story" do
    frame = Idml::Elements::TextFrame.from_xml('<TextFrame Self="t1"/>')
    described_class.render(canvas, build_context(frame))
    write_to_temp_pdf(writer, "tf-empty") do |path|
      raw = File.binread(path)
      expect(raw).not_to include("BT")
    end
  end

  it "skips frames that are not the chain head" do
    frame = Idml::Elements::TextFrame.from_xml(
      '<TextFrame Self="t1" ParentStory="s1" PreviousTextFrame="prev1"/>',
    )
    described_class.render(canvas, build_context(frame))
    write_to_temp_pdf(writer, "tf-chained") do |path|
      raw = File.binread(path)
      expect(raw).not_to include("BT")
    end
  end

  it "emits a BT/ET block when story resolves" do
    frame = first_text_frame
    skip "fixture has no text frame" unless frame

    described_class.render(canvas, build_context(frame))
    write_to_temp_pdf(writer, "tf-text") do |path|
      raw = File.binread(path)
      expect(raw).to include("BT")
      expect(raw).to include("ET")
    end
  end
end
