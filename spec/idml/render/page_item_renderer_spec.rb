# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::PageItemRenderer do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:graphic) { package.graphic }
  let(:color_resolver) { Idml::Render::ColorResolver.new(graphic) }

  describe ".renderer_for" do
    it "returns RectangleRenderer for Rectangle" do
      item = Idml::Elements::Rectangle.new
      expect(described_class.renderer_for(item)).to be(Idml::Render::Renderers::RectangleRenderer)
    end

    it "returns TextFrameRenderer for TextFrame" do
      item = Idml::Elements::TextFrame.new
      expect(described_class.renderer_for(item)).to be(Idml::Render::Renderers::TextFrameRenderer)
    end

    it "returns nil for unregistered types" do
      expect(described_class.renderer_for(Object.new)).to be_nil
    end
  end

  describe ".render" do
    it "returns nil for unregistered types" do
      context = Idml::Render::RenderContext.new(item: Object.new)
      expect(described_class.render(nil, context)).to be_nil
    end
  end
end
