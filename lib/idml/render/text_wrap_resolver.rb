# frozen_string_literal: true

module Idml
  module Render
    # Resolves text-wrap contours from page items that declare
    # TextWrapPreference. For BoundingBox mode (the common case),
    # the contour is the item's geometric bounds expanded by the
    # wrap offsets. TextFrameRenderer queries this resolver per
    # text line to compute the effective wrap width — lines that
    # overlap a contour get their width reduced by the overlap.
    #
    # Supported: BoundingBox mode (rectangle intersection).
    # Unsupported: Shape mode (contour following), Inverse mode.
    class TextWrapResolver
      # A wrap contour: a PDF-coordinate rectangle the text avoids.
      Contour = Struct.new(
        :x, :y, :width, :height,
        keyword_init: true
      )

      OFFSET_ATTRS = %i[
        offset_top offset_left offset_bottom offset_right
      ].freeze

      def self.build(spread, page_height: 792)
        contours = []
        spread.each_page_item do |item|
          contour = contour_for(item, page_height)
          contours << contour if contour
        end
        new(contours)
      end

      def initialize(contours)
        @contours = contours
      end

      attr_reader :contours

      # Returns the total horizontal overlap of all contours with a
      # text line at the given y range within the given x range.
      # Sum, not max — multiple overlapping contours compound.
      # Returns 0.0 when there's no overlap.
      def overlap_width(line_y, line_height, frame_x, frame_right)
        @contours.sum do |contour|
          if contour.is_a?(WrapContour::Shape)
            WrapContour.overlap_width(contour, line_y, line_height,
                                      frame_x, frame_right)
          else
            line_overlap(contour, line_y, line_height,
                         frame_x, frame_right)[:width]
          end
        end
      end

      # The wrap shape for an item: a bounding-box rectangle
      # (BoundingBoxTextWrap — the legacy "BoundingBox" spelling is
      # also accepted from early synthetic fixtures) or a flattened
      # PathGeometry polygon (Contour mode). JumpObject /
      # NextColumn modes approximate as the bounding box (the
      # per-run width reduction already pushes text past the
      # object).
      def self.contour_for(item, page_height)
        pref = wrap_preference(item)
        return nil unless pref

        if contour_mode?(pref)
          WrapContour.shape(item, pref, page_height)
        else
          box_contour(item, page_height)
        end
      end
      private_class_method :contour_for

      def self.box_contour(item, page_height)
        bounds = item.geometric_bounds
        return nil unless bounds

        rect = Geometry.placement_rect(bounds, item.item_transform,
                                       page_height)
        Contour.new(
          x: rect[:x], y: rect[:y],
          width: rect[:width], height: rect[:height]
        )
      end
      private_class_method :box_contour

      # Page item types that can declare TextWrapPreference per the
      # Spread schema. Used to guard the attribute read — querying
      # non-shape items (Page, Link) would raise NoMethodError.
      WRAPPABLE_TYPES = [
        Idml::Elements::Rectangle,
        Idml::Elements::Oval,
        Idml::Elements::Polygon,
        Idml::Elements::GraphicLine,
        Idml::Elements::Path,
        Idml::Elements::Group,
      ].freeze

      def self.wrap_preference(item)
        return nil unless wrappable?(item)

        pref = item.text_wrap_preference
        return nil if pref.nil? ||
          pref.text_wrap_mode.nil? ||
          pref.text_wrap_mode == "None"

        pref
      end
      private_class_method :wrap_preference

      def self.wrappable?(item)
        WRAPPABLE_TYPES.any? { |type| item.is_a?(type) }
      end
      private_class_method :wrappable?

      def self.contour_mode?(pref)
        pref.text_wrap_mode == "Contour"
      end
      private_class_method :contour_mode?

      def line_overlap(contour, line_y, line_height, frame_x, frame_right)
        return { width: 0.0 } unless y_overlap?(contour, line_y, line_height)
        return { width: 0.0 } unless x_overlap?(contour, frame_x, frame_right)

        { width: x_overlap_width(contour, frame_x, frame_right) }
      end

      def y_overlap?(contour, line_y, line_height)
        line_top = line_y + line_height
        line_bottom = line_y
        contour_top = contour.y + contour.height
        contour_bottom = contour.y
        line_top > contour_bottom && line_bottom < contour_top
      end

      def x_overlap?(contour, frame_x, frame_right)
        contour.x < frame_right && contour.x + contour.width > frame_x
      end

      def x_overlap_width(contour, frame_x, frame_right)
        left = [contour.x, frame_x].max
        right = [contour.x + contour.width, frame_right].min
        [right - left, 0].max
      end
    end
  end
end
