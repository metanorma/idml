# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

# Performance regression guard (TODO 141): a 120-page synthetic
# document renders end-to-end in bounded time. The generous 60s
# ceiling only trips on pathological complexity blowups (e.g. a
# per-page O(document) regression), not on machine noise.
PERF_PAGE_COUNT = 120
PERF_TIME_CEILING = 60.0

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  def font_path
    spec_font_path
  end

  def perf_story_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Story Self="u1">
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="10">
              <Content>#{'The quick brown fox jumps over the lazy dog. ' * 12}</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Story>
      </idPkg:Story>
    XML
  end

  def perf_spread_xml(index)
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <idPkg:Spread xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5">
        <Spread Self="s#{index}" ItemTransform="1 0 0 1 0 0">
          <Page Self="p#{index}" GeometricBounds="0 0 792 612" ItemTransform="1 0 0 1 0 0"/>
          <TextFrame Self="tf#{index}" ParentStory="u1" PreviousTextFrame="n" NextTextFrame="n" GeometricBounds="72 72 720 540" ItemTransform="1 0 0 1 0 0" ContentType="TextType" Visible="true"/>
        </Spread>
      </idPkg:Spread>
    XML
  end

  def perf_designmap_xml
    spread_refs = Array.new(PERF_PAGE_COUNT) do |index|
      %(<idPkg:Spread src="Spreads/Spread_s#{index}.xml"/>)
    end.join
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Designmap xmlns="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="21.5" SessionID="perf" DocumentUID="perf" Name="perf" PageRef="u1" CompositionOptions="CompositionOption/$ID/Normal" TransformOrigin="0 0" VisibleMovieTopic="FullQuality" EnhancedPagePreview="false" UndoHistory="2147483647" PreventManualWrag="false" CopyLinks="false" Language="en_US" Application="InDesign" DocumentSchema="CS5" StoryList="u1">
        #{spread_refs}
      </Designmap>
    XML
  end

  def perf_package
    parts = {
      "mimetype" => "application/vnd.adobe.indesign-idml-package",
      "designmap.xml" => perf_designmap_xml,
      "Stories/Story_u1.xml" => perf_story_xml,
    }
    Array.new(PERF_PAGE_COUNT) do |index|
      parts["Spreads/Spread_s#{index}.xml"] = perf_spread_xml(index)
    end
    dir = Dir.mktmpdir
    path = File.join(dir, "perf.idml")
    Idml::Package.write(parts: parts, to: path)
    Idml::Package.new(path)
  end

  it "renders a 120-page document within the time ceiling" do
    skip "no system font available" unless font_path

    package = perf_package
    expect(package.spreads.length).to eq(PERF_PAGE_COUNT)

    Dir.mktmpdir do |dir|
      path = File.join(dir, "perf.pdf")
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      described_class.render(package: package, to: path)
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      raw = File.binread(path)
      expect(raw).to start_with("%PDF")
      expect(raw.scan(/\/Type\s+\/Page\b/).length).to eq(PERF_PAGE_COUNT)
      expect(elapsed).to be < PERF_TIME_CEILING
    end
  end
end
