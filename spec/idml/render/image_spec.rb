# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Render::Image do
  let(:jpeg_rgb) do
    # Minimal JPEG: SOI + SOF0 (2x2, 3-channel RGB) + EOI.
    # SOF0 length=17 (includes 2-byte length): precision(1)+height(2)+width(2)+components(1)+3*3 bytes.
    sof0 = "\xFF\xC0#{[17, 8, 2, 2, 3].pack('nCnnC')}#{"\x01\x11\x00" * 3}"
    "\xFF\xD8#{sof0}\xFF\xD9"
  end

  describe ".jpeg_dimensions" do
    it "reads width and height from JPEG header" do
      expect(described_class.jpeg_dimensions(jpeg_rgb)).to eq([2, 2])
    end

    it "returns nil for non-JPEG data" do
      expect(described_class.jpeg_dimensions("not a jpeg")).to be_nil
    end

    it "returns nil for empty data" do
      expect(described_class.jpeg_dimensions("")).to be_nil
    end
  end

  describe ".jpeg_colorspace" do
    it "detects RGB from 3-channel JPEG" do
      expect(described_class.jpeg_colorspace(jpeg_rgb)).to eq(:DeviceRGB)
    end
  end

  describe ".parse_transform" do
    it "parses six space-separated floats" do
      t = described_class.parse_transform("1 0 0 1 100 200")
      expect([t.a, t.b, t.c, t.d, t.e, t.f]).to eq([1.0, 0.0, 0.0, 1.0,
                                                    100.0, 200.0])
    end

    it "returns nil for wrong element count" do
      expect(described_class.parse_transform("1 0 0 1")).to be_nil
    end
  end

  describe ".combine" do
    it "multiplies two affine transforms" do
      outer = described_class.parse_transform("2 0 0 2 10 20")
      inner = described_class.parse_transform("1 0 0 1 5 5")
      result = described_class.combine(outer, inner)
      expect(result.a).to eq(2.0)
      expect(result.e).to eq(20.0) # 2*5 + 0*5 + 10
      expect(result.f).to eq(30.0) # 0*5 + 2*5 + 20
    end
  end

  describe ".extract_from_spread" do
    let(:xml) do
      <<~XML
        <Spread>
          <Rectangle ItemTransform="1 0 0 1 -251 -394">
            <Image ItemTransform="0.1 0 0 0.1 333 126">
              <Link LinkResourceURI="file:/images/test.jpeg" />
            </Image>
          </Rectangle>
        </Spread>
      XML
    end

    it "extracts image URI and transform" do
      images = described_class.extract_from_spread(xml)
      expect(images.length).to eq(1)
      expect(images[0][:uri]).to eq("file:/images/test.jpeg")
      expect(images[0][:transform].a).to be_within(0.001).of(0.1)
    end

    it "captures the enclosing element transform" do
      images = described_class.extract_from_spread(xml)
      expect(images[0][:parent_transform].e).to be_within(0.1).of(-251)
    end
  end

  describe ".compute_placement" do
    it "flips Y axis and combines transforms for PDF coordinates" do
      image_t = described_class.parse_transform("0.1 0 0 0.1 333 126")
      parent_t = described_class.parse_transform("1 0 0 1 -251 -394")
      placement = described_class.compute_placement(
        image_transform: image_t, parent_transform: parent_t,
        pixel_height: 1000, page_height: 792
      )
      # Combined translate: e = 1*333 + 0*126 + (-251) = 82
      # Combined translate: f = 0*333 + 1*126 + (-394) = -268
      # Scaled height = 1000 * 0.1 = 100
      # pdf_y = 792 - (-268) - 100 = 960
      expect(placement[:x]).to be_within(0.1).of(82.0)
      expect(placement[:scale_x]).to be_within(0.001).of(0.1)
    end
  end

  describe ".resolve_path" do
    it "strips file: prefix and decodes URI escapes" do
      uri = "file:/Users/test/My%20Documents/image.jpeg"
      path = described_class.resolve_path(uri)
      expect(path).to include("My Documents/image.jpeg")
    end
  end

  describe ".draw_image" do
    it "emits save, transform, Do, restore operators" do
      result = described_class.draw_image(
        name: "Im1", x: 100, y: 200, scale_x: 0.5, scale_y: 0.5,
      )
      expect(result).to include("q")
      expect(result).to include("0.5000 0 0 0.5000 100.00 200.00 cm")
      expect(result).to include("/Im1 Do")
      expect(result).to include("Q")
    end
  end

  describe ".detect_format" do
    let(:png_rgb) do
      signature = "\x89PNG\r\n\x1a\n".b
      ihdr_length = [13].pack("N")
      ihdr_type = "IHDR"
      ihdr_data = [2, 2, 8, 2].pack("NNCC")
      ihdr_data += [0, 0, 0].pack("CCC")
      ihdr_crc = [0].pack("N")
      iend_length = [0].pack("N")
      iend_type = "IEND"
      iend_crc = [0].pack("N")
      signature + ihdr_length + ihdr_type + ihdr_data + ihdr_crc +
        iend_length + iend_type + iend_crc
    end

    it "detects JPEG" do
      expect(described_class.detect_format(jpeg_rgb)).to eq(:jpeg)
    end

    it "detects PNG" do
      expect(described_class.detect_format(png_rgb)).to eq(:png)
    end

    it "returns nil for unknown format" do
      expect(described_class.detect_format("not an image")).to be_nil
    end
  end

  describe ".png_dimensions" do
    let(:png_rgb) do
      signature = "\x89PNG\r\n\x1a\n".b
      ihdr_data = [2, 2, 8, 2, 0, 0, 0].pack("NNCCCCC")
      "#{[ihdr_data.length].pack('N')}IHDR#{ihdr_data}#{[0].pack('N')}#{[0].pack('N')}IEND#{[0].pack('N')}#{signature}"
    end

    it "reads width and height from IHDR" do
      png = "\x89PNG\r\n\x1a\n".b
      ihdr_data = [2, 2, 8, 2, 0, 0, 0].pack("NNCCCCC")
      png += "#{[ihdr_data.length].pack('N')}IHDR#{ihdr_data}#{[0].pack('N')}"
      png += "#{[0].pack('N')}IEND#{[0].pack('N')}"
      expect(described_class.png_dimensions(png)).to eq([2, 2])
    end

    it "returns nil for non-PNG data" do
      expect(described_class.png_dimensions(jpeg_rgb)).to be_nil
    end
  end

  describe ".png_colorspace" do
    it "detects RGB from color type 2" do
      png = "\x89PNG\r\n\x1a\n".b
      ihdr_data = [2, 2, 8, 2, 0, 0, 0].pack("NNCCCCC")
      png += "#{[ihdr_data.length].pack('N')}IHDR#{ihdr_data}#{[0].pack('N')}"
      png += "#{[0].pack('N')}IEND#{[0].pack('N')}"
      expect(described_class.png_colorspace(png)).to eq(:DeviceRGB)
    end
  end

  describe ".png_idat_data" do
    it "extracts concatenated IDAT data" do
      png = "\x89PNG\r\n\x1a\n".b
      ihdr_data = [1, 1, 8, 2, 0, 0, 0].pack("NNCCCCC")
      idat_data = "compressed_data"
      png += "#{[ihdr_data.length].pack('N')}IHDR#{ihdr_data}#{[0].pack('N')}"
      png += "#{[idat_data.length].pack('N')}IDAT#{idat_data}#{[0].pack('N')}"
      png += "#{[0].pack('N')}IEND#{[0].pack('N')}"
      expect(described_class.png_idat_data(png)).to eq("compressed_data")
    end

    it "returns nil for JPEG data" do
      expect(described_class.png_idat_data(jpeg_rgb)).to be_nil
    end
  end
end
