# frozen_string_literal: true

require "spec_helper"

FakeRenderRect = Struct.new(
  :visible, :fill_color, :geometric_bounds, :item_transform,
  :stroke_color, :stroke_weight, :transparency_setting,
  keyword_init: true
)

FakeRenderGraphic = Struct.new(:gradient, keyword_init: true)

FakeRenderPackage = Struct.new(:graphic, keyword_init: true)

FakeRenderColorResolver = Struct.new(:table, keyword_init: true) do
  def resolve(name)
    table[name]
  end
end

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::RectangleRenderer do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def build_gradient(type:)
    Idml::Elements::Gradient.new.tap do |g|
      g.self_attr = "Gradient/test"
      g.type = type
      g.gradient_stop = [
        build_stop("Color/c1", 0.0),
        build_stop("Color/c2", 1.0),
      ]
    end
  end

  def build_stop(color, location)
    Idml::Elements::GradientStop.new.tap do |s|
      s.stop_color = color
      s.location = location
    end
  end

  def build_color_resolver
    FakeRenderColorResolver.new(
      table: {
        "Color/c1" => { model: :rgb, r: 1, g: 0, b: 0 },
        "Color/c2" => { model: :rgb, r: 0, g: 0, b: 1 },
      },
    )
  end

  def build_rect(fill_color)
    FakeRenderRect.new(
      visible: true,
      fill_color: fill_color,
      geometric_bounds: [0, 0, 100, 100],
      item_transform: "1 0 0 1 0 0",
      stroke_color: nil,
      stroke_weight: nil,
      transparency_setting: nil,
    )
  end

  def build_context(rect, gradient)
    Idml::Render::RenderContext.new(
      item: rect,
      package: FakeRenderPackage.new(
        graphic: FakeRenderGraphic.new(gradient: [gradient]),
      ),
      color_resolver: build_color_resolver,
      page_height: 400,
    )
  end

  def shading_registry
    canvas.document.shadings.registry
  end

  shared_examples "renders a shading" do
    it "registers exactly one shading resource" do
      expect(shading_registry).to be_empty
      described_class.render(canvas, context)
      expect(shading_registry.length).to eq(1)
    end

    it "emits a rectangle path and shading fill" do
      described_class.render(canvas, context)
      write_to_temp_pdf(writer, "rect-render") do |path|
        raw = File.binread(path)
        expect(raw).to include(" re").or include("\nre\n")
        expect(raw).to include(" sh")
      end
    end
  end

  describe "linear gradient (default type)" do
    let(:gradient) { build_gradient(type: "Linear") }
    let(:context) { build_context(build_rect("Gradient/test"), gradient) }

    it_behaves_like "renders a shading"
  end

  describe "radial gradient" do
    let(:gradient) { build_gradient(type: "Radial") }
    let(:context) { build_context(build_rect("Gradient/test"), gradient) }

    it_behaves_like "renders a shading"
  end

  describe "gradient type falls back to axial" do
    let(:gradient) { build_gradient(type: nil) }
    let(:context) { build_context(build_rect("Gradient/test"), gradient) }

    it_behaves_like "renders a shading"
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
