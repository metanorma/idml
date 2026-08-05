# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Table. Draws the cell grid via rectangle
      # ops, then renders inline text in each cell via
      # `canvas.text_rich`. Cells with no text render as empty
      # rectangles.
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
      class TableRenderer
        DEFAULT_SIZE = 10.0
        INSET = 4.0

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
        def self.render_in_box(canvas, table, box, context)
          return if table.visible == false

          canvas.save_graphics_state do
            if schema_faithful?(table)
              render_schema_faithful(canvas, table, box, context)
            else
              render_legacy(canvas, table, box, context)
            end
          end
        end

        def self.schema_faithful?(table)
          !table.cell.empty? || !table.row.empty?
        end
        private_class_method :schema_faithful?

        # Real IDML: Table > {Cell, Row} siblings. Cell Name is
        # "col:row". Row count from `row` collection; column count
        # derived from max col + 1 across cells.
        def self.render_schema_faithful(canvas, table, box, context)
          layout = SchemaLayout.new(table: table, box: box)
          layout.each_cell do |cell_x, cell_y, cell_w, cell_h, cell|
            canvas.rectangle(cell_x, cell_y, cell_w, cell_h)
            canvas.stroke
            render_cell_text(canvas, cell, cell_x, cell_y, cell_h, context)
          end
        end
        private_class_method :render_schema_faithful

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
          text = cell.text_content
          return if text.nil? || text.empty?

          runs = [{
            text: text,
            font: context.font_ps_name,
            size: DEFAULT_SIZE,
          }]
          baseline = y + (height / 2)
          canvas.text_rich(runs, at: [x + INSET, baseline])
        end
        private_class_method :render_cell_text

        # Computes per-cell rects for the schema-faithful layout.
        # Row heights come from `Row#single_row_height` when present,
        # else fall back to evenly-divided table height. Column
        # widths are evenly divided (precise column widths would
        # require ColumnAttributes lookup, deferred).
        SchemaLayout = Struct.new(:table, :box, keyword_init: true) do
          def each_cell
            row_count.times do |row_idx|
              col_count.times do |col_idx|
                cell = cell_at(col_idx, row_idx)
                next unless cell

                yield cell_x(col_idx), cell_y(row_idx), cell_w, cell_h(row_idx),
                      cell
              end
            end
          end

          def row_count
            rows.length
          end

          def col_count
            @col_count ||= begin
              max_col = cells.filter_map(&:col_row).map(&:first).max || 0
              max_col + 1
            end
          end

          def rows
            table.row
          end

          def cells
            table.cell
          end

          def cell_at(col, row)
            cells.find { |c| c.col_row == [col, row] }
          end

          def cell_x(col)
            box[:x] + (col * cell_w)
          end

          def cell_y(row)
            box[:y] + total_height - cumulative_height(row) - cell_h(row)
          end

          def cell_w
            box[:width] / [col_count, 1].max
          end

          def cell_h(row_idx)
            row_heights[row_idx] || (box[:height] / [row_count, 1].max)
          end

          def row_heights
            @row_heights ||= rows.map do |row|
              h = row.single_row_height
              h&.positive? ? h : nil
            end
          end

          def total_height
            @total_height ||= row_count.times.sum { |i| cell_h(i) }
          end

          def cumulative_height(up_to_row)
            up_to_row.times.sum { |i| cell_h(i) }
          end
        end
        private_constant :SchemaLayout
      end
    end
  end
end
