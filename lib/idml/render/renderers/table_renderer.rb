# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Table. Draws the cell grid via rectangle
      # ops, then renders inline text in each cell. Cells with no
      # text render as empty rectangles.
      #
      # Two table layouts are supported:
      #
      #   1. **Schema-faithful** (real IDML): `Table` has `cell`
      #      and `row` sibling collections. Cell `Name` encodes
      #      column and row as `"col:row"`. Row order determines
      #      vertical position; cell Name determines horizontal.
      #   2. **Legacy** (synthetic test fixture): `Table` has a
      #      `table_row` collection, each `TableRow` has a
      #      `table_cell` collection. Nested structure.
      #
      # The renderer auto-detects which layout is present.
      #
      # Honors per-cell:
      # - `fill_color` / `fill_tint` — background fill before stroke.
      # - `top_inset` / `left_inset` / `bottom_inset` / `right_inset`
      #   — text insets (replaces fixed `INSET = 4.0`).
      # - `vertical_justification` — Top / Center / Bottom / Justify.
      # - `paragraph_style_range` → typed runs (per-run font + size).
      #
      # Honors per-table:
      # - `single_column_width` — overrides the even-division default
      #   for column widths.
      class TableRenderer
        DEFAULT_SIZE = 10.0
        DEFAULT_INSET = 4.0

        def self.render(canvas, context)
          table = context.item
          return if table.visible == false

          box = Placement.box(table, context.page_height)
          return unless box

          render_in_box(canvas, table, box, context)
        end

        # Renders a Table using caller-supplied bounds (no
        # Placement.box lookup). Used by TextFrameRenderer to
        # render Tables inlined in a story — real IDML Tables
        # have no own geometry, so the containing TextFrame's
        # bounds stand in for the Table's bounds.
        # Renders the table within `box`. When `bottom_limit` is
        # given, rows stop at the limit and the next unrendered row
        # index is returned (nil when the table completed) — the
        # caller threads it into the next frame of the chain via
        # `start_row`, which also re-emits HeaderRowCount header
        # rows above the continuation.
        def self.render_in_box(canvas, table, box, context, start_row: 0,
                                                     bottom_limit: nil)
          return if table.visible == false
          return nil if schema_faithful?(table) &&
            start_row >= table.row.length

          next_row = nil
          canvas.save_graphics_state do
            next_row = if schema_faithful?(table)
                         render_schema_faithful(canvas, table, box, context,
                                                start_row: start_row,
                                                bottom_limit: bottom_limit)
                       else
                         render_legacy(canvas, table, box, context)
                         nil
                       end
          end
          next_row
        end

        def self.schema_faithful?(table)
          !table.cell.empty? || !table.row.empty?
        end
        private_class_method :schema_faithful?

        # Real IDML: Table > {Cell, Row} siblings. Cell Name is
        # "col:row". Row count from `row` collection; column count
        # derived from `column_count` attribute or max col + 1.
        def self.render_schema_faithful(canvas, table, box, context,
                                        start_row: 0, bottom_limit: nil)
          layout = SchemaLayout.new(table: table, box: box)
          rendered, next_row = visible_row_range(
            layout, table, start_row, bottom_limit
          )
          rendered.each do |row_idx|
            render_row(canvas, table, layout, box, row_idx, context)
          end
          next_row
        end
        private_class_method :render_schema_faithful

        def self.render_row(canvas, table, layout, _box, row_idx, context)
          layout.each_cell_in_row(row_idx) do |cell_x, cell_y, cell_w,
                                              cell_h, cell, col_idx|
            render_band_background(canvas, cell, layout, col_idx, row_idx,
                                   cell_x, cell_y, cell_w, cell_h, context)
            render_cell_background(canvas, cell, cell_x, cell_y, cell_w,
                                   cell_h, context)
            render_cell_border(canvas, cell, table, cell_x, cell_y,
                               cell_w, cell_h, context)
            render_cell_text(canvas, cell, cell_x, cell_y, cell_h, context)
          end
        end
        private_class_method :render_row

        # [rows_to_render, next_unrendered_row]: header rows
        # re-emit on continuations (start_row > 0) with
        # HeaderRowCount; body rows run from start_row until the
        # frame bottom limit clips one.
        def self.visible_row_range(layout, table, start_row, bottom_limit)
          rows = continuation_header_rows(table, start_row) +
            body_rows_within(layout, table, start_row, bottom_limit)
          [rows, next_unrendered(layout, table, start_row, bottom_limit)]
        end
        private_class_method :visible_row_range

        def self.continuation_header_rows(table, start_row)
          return [] if start_row.zero?

          (table.header_row_count || 0).times.to_a
        end
        private_class_method :continuation_header_rows

        def self.body_rows_within(layout, table, start_row, bottom_limit)
          body_rows = (start_row...table.row.length).to_a
          return body_rows if bottom_limit.nil?

          body_rows.take_while do |row_idx|
            layout.row_bottom_y(row_idx) >= bottom_limit
          end
        end
        private_class_method :body_rows_within

        def self.next_unrendered(layout, table, start_row, bottom_limit)
          last = start_row + body_rows_within(
            layout, table, start_row, bottom_limit
          ).length - 1
          return nil if last >= table.row.length - 1

          last + 1
        end
        private_class_method :next_unrendered

        # Table-level alternating band fill behind a cell. An
        # explicit Cell FillColor wins; Color/None bands and zero
        # tints render nothing.
        def self.render_band_background(canvas, cell, layout, col_idx,
                                        row_idx, x, y, w, h, context)
          return if cell_fill_color(cell, context)

          name, tint = layout.band_fill(col_idx, row_idx)
          return unless name
          return if name == "Color/None"

          color = context.color_resolver&.resolve(name)
          return unless color

          color = ColorHelper.apply_tint(color, tint)
          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(x, y, w, h)
          canvas.fill
        end
        private_class_method :render_band_background

        def self.render_cell_background(canvas, cell, x, y, w, h, context)
          color = cell_fill_color(cell, context)
          return unless color

          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(x, y, w, h)
          canvas.fill
        end
        private_class_method :render_cell_background

        # Cell borders: per-side strokes when the cell or table
        # declare edge weights (legacy single rect otherwise, so
        # undeclared tables keep their existing look). Top/bottom
        # fall back to the table's default row stroke, left/right
        # to the default column stroke; zero-weight sides draw
        # nothing.
        def self.render_cell_border(canvas, cell, table, x, y, w, h, context)
          sides = cell_edge_weights(cell, table)
          if sides.nil?
            canvas.rectangle(x, y, w, h)
            canvas.stroke
            return
          end

          top, right, bottom, left = sides
          stroke_cell_side(canvas, context,
                           cell.top_edge_stroke_color,
                           table.default_row_stroke_color, top) do
            canvas.move_to(x, y + h)
            canvas.line_to(x + w, y + h)
          end
          stroke_cell_side(canvas, context,
                           cell.bottom_edge_stroke_color,
                           table.default_row_stroke_color, bottom) do
            canvas.move_to(x, y)
            canvas.line_to(x + w, y)
          end
          stroke_cell_side(canvas, context,
                           cell.left_edge_stroke_color,
                           table.default_column_stroke_color, left) do
            canvas.move_to(x, y)
            canvas.line_to(x, y + h)
          end
          stroke_cell_side(canvas, context,
                           cell.right_edge_stroke_color,
                           table.default_column_stroke_color, right) do
            canvas.move_to(x + w, y)
            canvas.line_to(x + w, y + h)
          end
        end
        private_class_method :render_cell_border

        # [top, right, bottom, left] effective weights, or nil when
        # neither cell edges nor table defaults declare any stroke
        # (the legacy uniform-rect case).
        def self.cell_edge_weights(cell, table)
          return nil unless stroke_declared?(cell, table)

          [
            side_weight(cell.top_edge_stroke_weight,
                        table.default_row_stroke_weight),
            side_weight(cell.right_edge_stroke_weight,
                        table.default_column_stroke_weight),
            side_weight(cell.bottom_edge_stroke_weight,
                        table.default_row_stroke_weight),
            side_weight(cell.left_edge_stroke_weight,
                        table.default_column_stroke_weight),
          ]
        end
        private_class_method :cell_edge_weights

        def self.stroke_declared?(cell, table)
          [
            cell.top_edge_stroke_weight, cell.right_edge_stroke_weight,
            cell.bottom_edge_stroke_weight, cell.left_edge_stroke_weight,
            table.default_row_stroke_weight,
            table.default_column_stroke_weight
          ].compact.any?
        end
        private_class_method :stroke_declared?

        def self.side_weight(cell_weight, default_weight)
          cell_weight || default_weight || 0
        end
        private_class_method :side_weight

        def self.stroke_cell_side(canvas, context, cell_color,
                                  table_color, weight)
          thickness = weight.to_f
          return unless thickness.positive?

          apply_cell_stroke_color(canvas, context, cell_color, table_color)
          canvas.line_width = thickness
          yield
          canvas.stroke
        end
        private_class_method :stroke_cell_side

        def self.apply_cell_stroke_color(canvas, context, cell_color,
                                         table_color)
          name = cell_color || table_color
          color = name && context.color_resolver&.resolve(name)
          canvas.stroke_color(color ? ColorHelper.to_canvas(color) : [:gray, 1.0])
        end
        private_class_method :apply_cell_stroke_color

        def self.cell_fill_color(cell, context)
          return nil unless cell.fill_color
          return nil if cell.fill_color == "Color/None"

          context.color_resolver&.resolve(cell.fill_color)
        end
        private_class_method :cell_fill_color

        # Legacy: Table > TableRow > TableCell nested.
        def self.render_legacy(canvas, table, box, context)
          return if table.table_row.empty?

          row_count = table.table_row.length
          row_height = box[:height] / row_count

          table.table_row.each_with_index do |row, row_index|
            row_y = box[:y] + ((row_count - 1 - row_index) * row_height)
            cell_count = row.table_cell.length
            next unless cell_count.positive?

            cell_width = box[:width] / cell_count
            row.table_cell.each_with_index do |cell, cell_index|
              cell_x = box[:x] + (cell_index * cell_width)
              canvas.rectangle(cell_x, row_y, cell_width, row_height)
              canvas.stroke
              render_cell_text(canvas, cell, cell_x, row_y, row_height,
                               context)
            end
          end
        end
        private_class_method :render_legacy

        def self.render_cell_text(canvas, cell, x, y, height, context)
          runs = cell_text_runs(cell, context)
          return if runs.empty?

          insets = cell_insets(cell)
          baseline = vertical_baseline(y, height, insets, cell)
          canvas.text_rich(runs, at: [x + insets[:left], baseline])
        end
        private_class_method :render_cell_text

        # Builds pdfrb runs from the cell's typed PSR/CSR children.
        # Walks ParagraphStyleRange → CharacterStyleRange → Content
        # so each run carries its own font + size (per-cell CSR
        # styling). Falls back to a single DEFAULT_SIZE run when
        # the cell has no typed paragraphs (legacy TableCell).
        def self.cell_text_runs(cell, context)
          psr = typed_paragraphs(cell)
          return default_text_runs(cell, context) if psr.empty?

          psr.flat_map { |paragraph| paragraph_runs(paragraph, context) }
        end
        private_class_method :cell_text_runs

        def self.paragraph_runs(paragraph, context)
          paragraph.character_style_range.filter_map do |csr|
            text = csr.text_content
            next if text.nil? || text.empty?

            {
              text: text,
              font: context.font_ps_name,
              size: csr.point_size || DEFAULT_SIZE,
            }
          end
        end
        private_class_method :paragraph_runs

        # Real IDML `Cell` exposes paragraph_style_range; the legacy
        # `TableCell` (synthetic fixture only) doesn't, so we treat
        # it as having no typed paragraphs and fall through to the
        # default_text_runs path.
        def self.typed_paragraphs(cell)
          return [] unless cell.is_a?(Idml::Elements::Cell)

          cell.paragraph_style_range
        end
        private_class_method :typed_paragraphs

        def self.default_text_runs(cell, context)
          text = cell.text_content
          return [] if text.nil? || text.empty?

          [{
            text: text,
            font: context.font_ps_name,
            size: DEFAULT_SIZE,
          }]
        end
        private_class_method :default_text_runs

        # Cell insets: prefer typed TextTopInset/Left/Bottom/Right,
        # fall back to DEFAULT_INSET for any that are missing.
        def self.cell_insets(cell)
          {
            top: cell.top_inset || DEFAULT_INSET,
            bottom: cell.bottom_inset || DEFAULT_INSET,
            left: cell.left_inset || DEFAULT_INSET,
            right: cell.right_inset || DEFAULT_INSET,
          }
        end
        private_class_method :cell_insets

        # Vertical baseline for the cell's first text line, per the
        # cell's VerticalJustification. IDML values: TopAlign,
        # CenterAlign, BottomAlign, JustifyAlign. Default: CenterAlign
        # (legacy behavior).
        def self.vertical_baseline(y, height, insets, cell)
          case cell.vertical_justification
          when "TopAlign"
            y + height - insets[:top]
          when "BottomAlign"
            y + insets[:bottom]
          else # CenterAlign, JustifyAlign, nil
            y + (height / 2)
          end
        end
        private_class_method :vertical_baseline

        # Computes per-cell rects for the schema-faithful layout.
        # Row heights come from `Row#single_row_height` when present,
        # else fall back to evenly-divided table height. Column
        # widths come from `Table#single_column_width` when present
        # (uniform columns only — per-column widths would require
        # ColumnAttributes, which IDML doesn't model separately),
        # else divide evenly.
        #
        # Honors `Cell#column_span` and `Cell#row_span`: a spanning
        # cell covers multiple grid positions and is rendered once
        # at its top-left corner with the merged rect. Cells covered
        # by another cell's span are skipped.
        SchemaLayout = Struct.new(:table, :box, keyword_init: true) do
          def each_cell
            covered = Set.new

            row_count.times do |row_idx|
              col_count.times do |col_idx|
                next if covered.include?([col_idx, row_idx])

                cell = cell_at(col_idx, row_idx)
                next unless cell

                col_span = cell.column_span || 1
                row_span = cell.row_span || 1
                mark_covered(covered, col_idx, row_idx, col_span, row_span)

                yield cell_x(col_idx), cell_y(row_idx, col_span, row_span),
                      cell_w(col_idx, col_span), cell_h(row_idx, row_span),
                      cell, col_idx, row_idx
              end
            end
          end

          def row_count
            rows.length
          end

          def col_count
            @col_count ||= begin
              declared = table.column_count
              declared&.positive? ? declared : derived_col_count
            end
          end

          def derived_col_count
            max_col = cells.filter_map(&:col_row).map(&:first).max || 0
            max_col + 1
          end

          def rows
            table.row
          end

          # Cells whose START row is `row` (cells spanning from an
          # earlier row render there, not here).
          def each_cell_in_row(row)
            col_count.times do |col_idx|
              cell = cell_at(col_idx, row)
              next unless cell
              next unless cell.col_row.nil? || cell.col_row.last == row

              col_span = cell.column_span || 1
              row_span = cell.row_span || 1
              yield cell_x(col_idx), cell_y(row, col_span, row_span),
                    cell_w(col_idx, col_span), cell_h(row, row_span),
                    cell, col_idx
            end
          end

          # The bottom y of a row's band (PDF coords).
          def row_bottom_y(row)
            box[:y] + total_height - cumulative_height(row + 1)
          end

          # Table-level alternating band fill for a cell position:
          # [color_name, tint] or nil. Row banding by default; column
          # banding when ColumnFillsPriority is true or rows are
          # unconfigured.
          def band_fill(col, row)
            column_band = column_band_fill(col)
            return column_band if column_band &&
              (table.column_fills_priority || row_band_fill(row).nil?)

            row_band_fill(row)
          end

          def row_band_fill(row)
            band_pair(table.start_row_fill_color, table.start_row_fill_count,
                      table.end_row_fill_color, table.end_row_fill_count,
                      table.start_row_fill_tint, table.end_row_fill_tint,
                      row, row_count,
                      table.skip_first_alternating_fill_rows,
                      table.skip_last_alternating_fill_rows)
          end
          private :row_band_fill

          def column_band_fill(col)
            band_pair(table.start_column_fill_color,
                      table.start_column_fill_count,
                      table.end_column_fill_color,
                      table.end_column_fill_count,
                      table.start_column_fill_tint,
                      table.end_column_fill_tint,
                      col, col_count,
                      table.skip_first_alternating_fill_columns,
                      table.skip_last_alternating_fill_columns)
          end
          private :column_band_fill

          # Alternating band for one axis: the first `start_count`
          # positions take the start color, the next `end_count` the
          # end color, repeating from after the skipped edge rows.
          # Zero-count cycles band nothing.
          def band_pair(start_color, start_count, end_color, end_count,
                        start_tint, end_tint, index, total,
                        skip_first, skip_last)
            return nil unless start_color
            return nil if suppressed?(index, total, skip_first, skip_last)

            cycle = band_cycle(start_count, end_count)
            return nil unless cycle.positive?

            if in_start_band?(index, skip_first, cycle, start_count)
              [start_color, start_tint]
            else
              [end_color, end_tint]
            end
          end
          private :band_pair

          def band_cycle(start_count, end_count)
            (start_count || 1) + (end_count || 1)
          end
          private :band_cycle

          def in_start_band?(index, skip_first, cycle, start_count)
            ((index - (skip_first || 0)) % cycle) < (start_count || 1)
          end
          private :in_start_band?

          # Banding suppressed at the leading/trailing edges.
          def suppressed?(index, total, skip_first, skip_last)
            index < (skip_first || 0) ||
              index >= total - (skip_last || 0)
          end
          private :suppressed?

          def cells
            table.cell
          end

          def cell_at(col, row)
            cells.find { |c| c.col_row == [col, row] }
          end

          def mark_covered(covered, col, row, col_span, row_span)
            col_span.times do |dc|
              row_span.times do |dr|
                covered << [col + dc, row + dr]
              end
            end
          end
          private :mark_covered

          def cell_x(col)
            box[:x] + cumulative_col_width(col)
          end

          # PDF-coordinate bottom y of the cell's rectangle. For a
          # row_spanning cell, this is the bottom edge of the last
          # spanned row. PDF rectangle takes (x, y_bottom, w, h).
          def cell_y(row, _col_span, row_span)
            last_row = row + row_span - 1
            box[:y] + total_height - cumulative_height(last_row + 1)
          end

          # Width covered by `span` columns starting at `col`. Uses
          # per-column widths from Column elements when available;
          # falls back to uniform width when not.
          def cell_w(col, span)
            span.to_i.times.sum { |i| column_width_at(col + i) }
          end

          # Total height covered by `span` rows starting at `row_idx`.
          def cell_h(row_idx, span)
            (span || 1).times.sum { |i| row_height(row_idx + i) }
          end

          def per_col_width
            return @per_col_width if @per_col_width

            declared = table.single_column_width
            @per_col_width = if declared&.positive?
                               declared
                             else
                               box[:width] / [col_count, 1].max
                             end
          end

          # Returns per-column widths from Column elements when
          # present; empty array otherwise. When non-empty, the
          # renderer uses per-column widths for x positions and
          # span widths instead of uniform per_col_width.
          def per_column_widths
            return @per_column_widths if defined?(@per_column_widths)

            cols = table.column
            @per_column_widths = if cols.empty?
                                   []
                                 else
                                   cols.filter_map do |col|
                                     w = col.single_column_width
                                     w&.positive? ? w : nil
                                   end
                                 end
          end

          # Width of a single column at index `idx`. Uses per-column
          # widths when available; falls back to uniform.
          def column_width_at(idx)
            return per_col_width if per_column_widths.empty?
            return per_col_width unless idx.between?(0, per_column_widths.length - 1)

            per_column_widths[idx]
          end

          # Cumulative width from column 0 up to (but not including)
          # column `col`. Used for x positioning.
          def cumulative_col_width(col)
            return col * per_col_width if per_column_widths.empty?

            col.times.sum { |i| column_width_at(i) }
          end

          def row_height(idx)
            return 0.0 unless idx.between?(0, row_count - 1)

            row_heights[idx] || (box[:height] / [row_count, 1].max)
          end

          def row_heights
            @row_heights ||= rows.map do |row|
              h = row.single_row_height
              h&.positive? ? h : nil
            end
          end

          def total_height
            @total_height ||= row_count.times.sum { |i| row_height(i) }
          end

          def cumulative_height(up_to_row)
            up_to_row.times.sum { |i| row_height(i) }
          end
        end
        private_constant :SchemaLayout
      end
    end
  end
end
