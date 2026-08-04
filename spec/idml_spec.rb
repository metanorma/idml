# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml do
  let(:fixture_path) do
    File.expand_path("fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "Fonts.xml typed model" do
    it "parses FontFamily entries with Font children" do
      fonts = package.fonts
      expect(fonts.font_family).to be_an(Array)
      expect(fonts.font_family).not_to be_empty
    end

    it "FontFamily exposes Name attribute" do
      family = package.fonts.font_family.first
      expect(family.name).to be_a(String)
    end

    it "Font exposes PostScriptName" do
      font = package.fonts.font_family.first.font.first
      expect(font.post_script_name).to be_a(String)
      expect(font.post_script_name).not_to be_empty
    end
  end

  describe "Master spread rendering" do
    it "Package resolves master spread by Page's AppliedMaster" do
      spread = package.spreads.first
      page = spread.spread.first.page.first
      master = package.master_spread_by_id(page.applied_master)
      expect(master).to be_a(Idml::Parts::MasterSpread)
    end

    it "MasterSpreadObject has page item collections" do
      master = package.master_spreads.first
      ms_obj = master.master_spread.first
      expect(ms_obj.rectangle).to be_an(Array)
      expect(ms_obj.text_frame).to be_an(Array)
      expect(ms_obj.each_page_item).to be_an(Enumerator)
    end

    it "Designmap parses Layer child elements" do
      dm = package.designmap
      expect(dm.layer).to be_an(Array)
      expect(dm.layer).not_to be_empty
      expect(dm.layer.first.visible).to be true
    end
  end
end
