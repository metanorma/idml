# frozen_string_literal: true

require "spec_helper"

# KeepPolicy unit surface (TODO 149): the paragraph-deferral
# predicates tested directly — no canvas, writer, or fonts — with
# real StyleResolver::Paragraph structs and a TextEngine::Frame.
RSpec.describe Idml::Render::Renderers::KeepPolicy do
  def paragraph(attrs = {})
    runs = attrs.delete(:runs) || [Idml::Render::StyleResolver::StyledRun.new(
      text: "word " * 12, point_size: 12.0,
    )]
    Idml::Render::StyleResolver::Paragraph.new(runs: runs, **attrs)
  end

  def frame
    Idml::TextEngine::Frame.new(
      x: 0, y: 0, width: 200, height: 400,
      inset_top: 0, inset_bottom: 0, inset_left: 0, inset_right: 0
    )
  end

  def font
    font_path = spec_font_path
    skip "no system font available" unless font_path

    doc = Pdfrb::Document.new
    resource = doc.fonts.add(font_path)
    Idml::TextEngine::PdfrbFontMetrics.new(doc.fonts, resource)
  end

  describe ".paragraph_break?" do
    it "is true for the StartParagraph break flavors" do
      expect(described_class.paragraph_break?(
               paragraph(start_paragraph: "NextPage"),
             )).to be true
      expect(described_class.paragraph_break?(
               paragraph(start_paragraph: "NextColumn"),
             )).to be true
    end

    it "is false unset or for arbitrary strings" do
      expect(described_class.paragraph_break?(paragraph)).to be false
      expect(described_class.paragraph_break?(
               paragraph(start_paragraph: "Anywhere"),
             )).to be false
    end
  end

  describe ".paragraph_deferred?" do
    it "defers on a forced break once something is placed" do
      para = paragraph(start_paragraph: "NextPage")
      expect(
        described_class.paragraph_deferred?(para, nil, frame, font,
                                            380, 20, true),
      ).to be true
    end

    it "never defers the frame's first paragraph (progress guarantee)" do
      para = paragraph(start_paragraph: "NextPage",
                       keep_all_lines_together: true)
      expect(
        described_class.paragraph_deferred?(para, nil, frame, font,
                                            380, 20, false),
      ).to be false
    end

    it "keeps a fitting paragraph inline" do
      para = paragraph(keep_all_lines_together: true)
      expect(
        described_class.paragraph_deferred?(para, nil, frame, font,
                                            380, 20, true),
      ).to be false
    end
  end

  describe ".keep_all_lines_break?" do
    it "defers when the block cannot fit the remaining space" do
      tall = paragraph(runs: [
                         Idml::Render::StyleResolver::StyledRun.new(
                           text: "word " * 200, point_size: 12.0,
                         ),
                       ], keep_all_lines_together: true)
      expect(
        described_class.keep_all_lines_break?(tall, frame, font, 100, 20),
      ).to be true
    end

    it "is false without the flag" do
      expect(
        described_class.keep_all_lines_break?(paragraph, frame, font,
                                              100, 20),
      ).to be false
    end
  end

  describe "partial keep windows" do
    it "defers when fewer than KeepFirstLines lines fit" do
      para = paragraph(keep_first_lines: 3)
      # ~10pt leading above a 20pt bottom limit leaves no full line.
      expect(
        described_class.keep_windows_break?(para, frame, font, 30, 20),
      ).to be true
    end

    it "does not defer when the whole block fits" do
      para = paragraph(keep_first_lines: 3, keep_last_lines: 2)
      expect(
        described_class.keep_windows_break?(para, frame, font, 380, 20),
      ).to be false
    end

    it "first_window_break? compares fit against the window" do
      expect(described_class.first_window_break?(
               paragraph(keep_first_lines: 3), 2
             )).to be true
      expect(described_class.first_window_break?(
               paragraph(keep_first_lines: 3), 3
             )).to be false
    end

    it "last_window_break? defers when the tail would strand lines" do
      para = paragraph(keep_last_lines: 2)
      # 10 total lines, 9 fit → tail of 1 < KeepLastLines 2.
      expect(
        described_class.last_window_break?(para, 9, 100.0, 10.0),
      ).to be true
      # Tail of 2 meets the window.
      expect(
        described_class.last_window_break?(para, 8, 100.0, 10.0),
      ).to be false
    end
  end

  describe ".keep_with_next_break?" do
    it "binds to a follower whose first line would not fit" do
      lead = paragraph(keep_with_next: true)
      follower = paragraph
      # Lead fills nearly everything; follower leading won't fit.
      tall_lead = paragraph(keep_with_next: true, runs: [
                              Idml::Render::StyleResolver::StyledRun.new(
                                text: "word " * 200, point_size: 12.0,
                              ),
                            ])
      expect(
        described_class.keep_with_next_break?(tall_lead, follower,
                                              frame, font, 100, 20),
      ).to be true
      expect(
        described_class.keep_with_next_break?(lead, follower,
                                              frame, font, 380, 20),
      ).to be false
    end

    it "is false without KeepWithNext or without a follower" do
      expect(
        described_class.keep_with_next_break?(paragraph, nil,
                                              frame, font, 380, 20),
      ).to be false
    end

    it "defers when the follower forces a break" do
      lead = paragraph(keep_with_next: true)
      follower = paragraph(start_paragraph: "NextPage")
      expect(
        described_class.keep_with_next_break?(lead, follower,
                                              frame, font, 380, 20),
      ).to be true
    end
  end
end
