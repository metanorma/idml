# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

# JumpObjectTextWrap end-to-end (TODO 143): text flows BELOW the
# wrapping object, never beside it. The object spans the frame's
# full width in its top band; all text baselines must land under
# the object's bottom edge, vs near the frame top without wrap.

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  def font_path
    spec_font_path
  end

  # The candidate's PostScript name resolvable within its own
  # directory (the pipeline resolves document fonts by PS name).
  def resolvable_ps_name
    return nil unless font_path

    resolver = Pdfrb::FontResolver.new(
      search_paths: [File.dirname(font_path)],
    )
    %w[ArialMT Arial Helvetica DejaVuSans].find do |name|
      resolver.find_by_ps_name(name)
    end
  end

  def jump_fonts_xml(ps_name)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Fonts xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <FontFamily Self="FontFamily/$ID/Arial" Name="Arial">
          <Font Self="FontFamily/$ID/Arial Regular" FontFamily="Arial" Name="Regular" PostScriptName="#{ps_name}" Status="Installed"/>
        </FontFamily>
      </idPkg:Fonts>
    XML
  end

  def jump_story_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="12">
              <Content>#{'First line of body text. ' * 6}</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  # Object spans the frame's full width from above the frame
  # top (idml y 60, frame top 72) down to idml y 160 → its PDF
  # bottom edge sits at 400 - 160 = 240. Covering the frame top
  # matters: the wrap is measured at each run's top cursor, so
  # the object must overlap that band to block the first run.
  def jump_spread_xml(mode)
    wrap = mode ? %(<TextWrapPreference TextWrapMode="#{mode}"/>) : ""
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Spread xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Spread Self="s0" ItemTransform="1 0 0 1 0 0">
          <Page Self="p0" GeometricBounds="0 0 400 400" ItemTransform="1 0 0 1 0 0"/>
          <TextFrame Self="tf0" ParentStory="u1" PreviousTextFrame="n" NextTextFrame="n" GeometricBounds="72 72 320 328" ItemTransform="1 0 0 1 0 0" ContentType="TextType" Visible="true"/>
          <Rectangle Self="r0" ItemTransform="1 0 0 1 0 0" Visible="true">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                  <PathPointArray>
                    <PathPointType Anchor="60 60" LeftDirection="60 60" RightDirection="60 60"/>
                    <PathPointType Anchor="60 160" LeftDirection="60 160" RightDirection="60 160"/>
                    <PathPointType Anchor="340 160" LeftDirection="340 160" RightDirection="340 160"/>
                    <PathPointType Anchor="340 60" LeftDirection="340 60" RightDirection="340 60"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            #{wrap}
          </Rectangle>
        </Spread>
      </idPkg:Spread>
    XML
  end

  def jump_designmap_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Designmap xmlns="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5" SessionID="jump" DocumentUID="jump" Name="jump" StoryList="u1">
        <idPkg:Spread src="Spreads/Spread_s0.xml"/>
      </Designmap>
    XML
  end

  def jump_render(mode)
    ps_name = resolvable_ps_name
    dir = Dir.mktmpdir
    path = File.join(dir, "jump.idml")
    Idml::Package.write(
      parts: {
        "mimetype" => "application/vnd.adobe.indesign-idml-package",
        "designmap.xml" => jump_designmap_xml,
        "Resources/Fonts.xml" => jump_fonts_xml(ps_name),
        "Stories/Story_u1.xml" => jump_story_xml,
        "Spreads/Spread_s0.xml" => jump_spread_xml(mode),
      },
      to: path,
    )
    text_ys(Idml::Package.new(path))
  end

  def text_ys(package)
    Dir.mktmpdir do |out_dir|
      pdf = File.join(out_dir, "jump.pdf")
      described_class.render(
        package: package, to: pdf,
        font_search_paths: [File.dirname(font_path)]
      )
      return File.binread(pdf)
          .scan(/1 0 0 1 (-?\d+(?:\.\d+)?) (-?\d+(?:\.\d+)?) Tm\n/)
          .map { |_x, y| y.to_f }
    end
  end

  it "renders all text below a full-width JumpObject" do
    skip "no system font available" unless resolvable_ps_name

    ys = jump_render("JumpObjectTextWrap")
    expect(ys).not_to be_empty
    # Object bottom edge: idml y 160 → PDF y 240.
    expect(ys.max).to be < 240
  end

  it "keeps text at the frame top without wrap" do
    skip "no system font available" unless resolvable_ps_name

    ys = jump_render(nil)
    expect(ys).not_to be_empty
    expect(ys.max).to be > 300
  end
end
