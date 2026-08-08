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
        # derived from `column_count` attribute or max col + 1.
        def self.render_schema_faithful(canvas, table, box, context)
          layout = SchemaLayout.new(table: table, box: box)
          layout.each_cell do |cell_x, cell_y, cell_w, cell_h, cell|
            render_cell_background(canvas, cell, cell_x, cell_y, cell_w, cell_h,
                                   context)
            render_cell_border(canvas, cell_x, cell_y, cell_w, cell_h)
            render_cell_text(canvas, cell, cell_x, cell_y, cell_h, context)
          end
        end
        private_class_method :render_schema_faithful

        def self.render_cell_background(canvas, cell, x, y, w, h, context)
          color = cell_fill_color(cell, context)
          return unless color

          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(x, y, w, h)
          canvas.fill
        end
        private_class_method :render_cell_background

        def self.render_cell_border(canvas, x, y, w, h)
          canvas.rectangle(x, y, w, h)
          canvas.stroke
        end
        private_class_method :render_cell_border

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
            return @cell_w if @cell_w

            declared = table.single_column_width
            per_col = if declared&.positive?
                        declared
                      else
                        box[:width] / [col_count, 1].max
                      end
            @cell_w = per_col
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
