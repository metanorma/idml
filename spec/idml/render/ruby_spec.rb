# frozen_string_literal: true

require "spec_helper"

# Ruby (phonetic annotation) extraction and rendering.
RUBY_FONT_CANDIDATES = [
  "/System/Library/Fonts/Supplemental/Arial.ttf",
  "/System/Library/Fonts/Hiragino Sans.ttc",
  "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
  "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
  "C:/Windows/Fonts/arial.ttf",
].freeze

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TextFrameRenderer do
  describe "ruby annotations" do
    def font_path
      RUBY_FONT_CANDIDATES.find { |p| File.exist?(p) }
    end

    def ruby_story_xml(ruby_attrs)
      <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
          <Story Self="u1">
            <ParagraphStyleRange>
              <CharacterStyleRange PointSize="12" RubyFlag="1" #{ruby_attrs}>
                <Content>漢字</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
          </Story>
        </idPkg:Story>
      XML
    end

    it "extracts ruby attributes onto the run" do
      story = Idml::Parts::Story.from_xml(
        ruby_story_xml('RubyString="かんじ" RubyFontSize="6"'),
      )
      run = Idml::Render::StyleResolver.extract_paragraphs(story).first.runs.first
      expect(run.ruby_string).to eq("かんじ")
      expect(run.ruby_font_size).to eq(6.0)
      expect(run.ruby_position).to be_nil
    end

    it "leaves runs without ruby unannotated" do
      story = Idml::Parts::Story.from_xml(ruby_story_xml(""))
      run = Idml::Render::StyleResolver.extract_paragraphs(story).first.runs.first
      expect(run.ruby_string).to be_nil
    end

    it "renders the ruby as an extra text block above the base text" do
      skip "no system font available" unless font_path

      with_ruby = Idml::Parts::Story.from_xml(
        ruby_story_xml('RubyString="かんじ" RubyFontSize="6"'),
      )
      without_ruby = Idml::Parts::Story.from_xml(ruby_story_xml(""))

      with_count = text_block_count(with_ruby)
      without_count = text_block_count(without_ruby)
      expect(with_count).to eq(without_count + 1)
    end
  end

  def text_block_count(story)
    dir = Dir.mktmpdir
    path = File.join(dir, "ruby.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "Stories/Story_u1.xml" => Idml::Parts::Story.to_xml(story),
      },
      to: path,
    )
    writer = Idml::Render::PdfrbWriter.new
    canvas = writer.add_page(width: 400, height: 400)
    described_class.render(canvas, render_context(writer, path))

    write_to_temp_pdf(writer, "ruby-e2e") do |pdf_path|
      File.binread(pdf_path).scan(/BT\b/).length
    end
  end

  def render_context(writer, package_path)
    package = Idml::Package.new(package_path)
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
end
# rubocop:enable RSpec/SpecFilePathFormat
