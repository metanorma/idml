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
    # Supported: BoundingBox mode (rectangle intersection) with
    # TextWrapSide awareness (LeftSide / RightSide / LargestArea
    # pick the side text flows on; BothSides and the spine variants
    # narrow by the full overlap). Shape contours (Contour mode)
    # narrow by polygon overlap without side awareness.
    # Unsupported: Inverse mode's side behavior.
    class TextWrapResolver
      # A wrap contour: a PDF-coordinate rectangle the text avoids.
      Contour = Struct.new(
        :x, :y, :width, :height, :inverse, :side, :jump,
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

      # Side-aware adjustment for a text line: returns
      # [width_reduction, x_shift]. LeftSide keeps text left of the
      # contour (reduce, no shift); RightSide moves text past the
      # contour's right edge (reduce + shift); LargestArea picks the
      # roomier side; BothSides and the spine variants (which need
      # binding-side context) reduce by the full overlap. Multiple
      # contours combine by max — the per-run approximation.
      def wrap_adjustment(line_y, line_height, frame_x, frame_right)
        reduction = 0.0
        shift = 0.0
        @contours.each do |contour|
          unless contour.is_a?(WrapContour::Shape)
            r, s = box_adjustment(contour, line_y, line_height,
                                  frame_x, frame_right)
            reduction = [reduction, r].max
            shift = [shift, s].max
            next
          end

          width = WrapContour.overlap_width(contour, line_y,
                                            line_height, frame_x,
                                            frame_right)
          next unless contour.inverse

          reduction = [reduction,
                       (frame_right - frame_x) - width].max
        end
        [reduction, shift]
      end

      def box_adjustment(contour, line_y, line_height, frame_x,
                         frame_right)
        overlap = if y_overlap?(contour, line_y, line_height) &&
            x_overlap?(contour, frame_x, frame_right)
                    x_overlap_width(contour, frame_x, frame_right)
                  else
                    0.0
                  end
        # Inverse contours: text flows only inside, so the reduction
        # is the frame width minus the covered part (the full width
        # when the line misses the object entirely).
        return [(frame_right - frame_x) - overlap, 0.0] if contour.inverse

        return [0.0, 0.0] if overlap.zero?

        # JumpObject: text never flows beside the object — the full
        # frame width is blocked and the renderer skips the run
        # below the object's bottom edge.
        return [frame_right - frame_x, 0.0] if contour.jump

        side_adjustment(contour, overlap, frame_x, frame_right)
      end
      private :box_adjustment

      # Bottom edge of the lowest jump contour overlapping the given
      # band — where text resumes below a JumpObject. nil when no
      # jump contour blocks the band.
      def jump_contour_bottom(line_y, line_height, frame_x, frame_right)
        bottoms = @contours.filter_map do |contour|
          next unless box_contour?(contour) && contour.jump
          next unless y_overlap?(contour, line_y, line_height) &&
            x_overlap?(contour, frame_x, frame_right)

          contour.y
        end
        bottoms.min
      end

      def box_contour?(contour)
        !contour.is_a?(WrapContour::Shape)
      end
      private :box_contour?

      def side_adjustment(contour, overlap, frame_x, frame_right)
        case contour.side
        when "LeftSide"
          [frame_right - contour.x, 0.0]
        when "RightSide"
          shift = contour.x + contour.width - frame_x
          [shift, shift]
        when "LargestArea"
          largest_side_adjustment(contour, frame_x, frame_right)
        else
          [overlap, 0.0]
        end
      end
      private :side_adjustment

      def largest_side_adjustment(contour, frame_x, frame_right)
        left_free = contour.x - frame_x
        right_free = frame_right - (contour.x + contour.width)
        return [frame_right - contour.x, 0.0] if left_free >= right_free

        shift = contour.x + contour.width - frame_x
        [shift, shift]
      end
      private :largest_side_adjustment

      # Returns the total horizontal overlap of all contours with a
      # text line at the given y range within the given x range.
      # Sum, not max — multiple overlapping contours compound.
      # Returns 0.0 when there's no overlap. Inverse contours
      # reduce by the frame width minus their own width (text may
      # only flow inside).
      def overlap_width(line_y, line_height, frame_x, frame_right)
        @contours.sum do |contour|
          width = if contour.is_a?(WrapContour::Shape)
                    WrapContour.overlap_width(contour, line_y,
                                              line_height, frame_x,
                                              frame_right)
                  else
                    line_overlap(contour, line_y, line_height,
                                 frame_x, frame_right)[:width]
                  end
          next width unless contour.inverse

          (frame_right - frame_x) - width
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
          box_contour(item, page_height, pref)
        end
      end
      private_class_method :contour_for

      def self.box_contour(item, page_height, pref = nil)
        bounds = item.geometric_bounds
        return nil unless bounds

        rect = Geometry.placement_rect(bounds, item.item_transform,
                                       page_height)
        Contour.new(
          x: rect[:x], y: rect[:y],
          width: rect[:width], height: rect[:height],
          side: pref&.text_wrap_side,
          jump: pref&.text_wrap_mode == "JumpObjectTextWrap"
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
