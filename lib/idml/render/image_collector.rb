# frozen_string_literal: true

module Idml
  module Render
    # Walks a Spread's page items, resolves image URIs against the
    # package's base directory, deduplicates by URI, and emits
    # placement refs (`{ name:, placement:, clip_box: }`) ready for
    # `SpreadRenderer#render_images`.
    #
    # Extracted from `Pipeline` so the pipeline stays a sequence of
    # high-level steps and the image-loading details live behind one
    # object. Owns: file I/O, format detection, deduplication,
    # placement math. Does not own: rendering (SpreadRenderer draws),
    # layer filtering (caller passes a visible-only iterable).
    class ImageCollector
      DEFAULT_PAGE_HEIGHT = 792

      def initialize(writer:, base_dir:, page_height: DEFAULT_PAGE_HEIGHT)
        @writer = writer
        @base_dir = base_dir
        @page_height = page_height
      end

      # Enumerate every page item in `spread`, register its image
      # children with the writer, and return the list of placement
      # refs. Items whose `image` collection is empty or whose URIs
      # cannot be resolved are skipped silently.
      def collect(spread)
        refs = []
        spread.each_page_item do |item|
          images_for(item).each do |image|
            ref = register(image, item)
            refs << ref if ref
          end
        end
        refs
      end

      private

      def images_for(item)
        case item
        when Idml::Elements::Rectangle, Idml::Elements::Polygon
          item.image || []
        else
          []
        end
      end

      def register(image, parent)
        uri = image.resource_uri
        return nil unless uri

        existing = @writer.image_name_for(uri)
        return reuse(existing, image, parent) if existing

        load_new(image, parent, uri)
      end

      def reuse(name, image, parent)
        { name: name, placement: placement_for(image, parent),
          clip_box: clip_box_for(parent) }
      end

      def load_new(image, parent, uri)
        path = Image.resolve_path(uri, base_dir: @base_dir)
        return nil unless File.exist?(path)

        data = File.binread(path)
        dims = dimensions_of(data)
        return nil unless dims

        name = @writer.add_image(data: data)
        @writer.register_image_name(uri, name)
        { name: name, placement: placement_for(image, parent, dims[1]),
          clip_box: clip_box_for(parent) }
      end

      def clip_box_for(parent)
        return nil unless parent.geometric_bounds

        Geometry.placement_rect(parent.geometric_bounds,
                                parent.item_transform, @page_height)
      end

      def dimensions_of(data)
        format = Image.detect_format(data)
        return nil unless format

        format == :png ? Image.png_dimensions(data) : Image.jpeg_dimensions(data)
      end

      def placement_for(image, parent, pixel_height = 100)
        Image.compute_placement(
          image_transform: parse_transform(image.item_transform),
          parent_transform: parse_transform(parent.item_transform),
          pixel_height: pixel_height,
          page_height: @page_height,
        )
      end

      def parse_transform(raw)
        Image.parse_transform(raw) || Image.identity
      end
    end
  end
end
