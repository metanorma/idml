# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Table as a grid of stroked rectangles.
      # Each TableRow becomes a horizontal strip; each TableCell within
      # a row becomes a column. Cell backgrounds and borders are drawn;
      # cell text content is skipped (text layout within tables
      # requires the full text engine pipeline which is future work).
      class TableRenderer
        def self.render(context)
          table = context.item
          return nil if table.visible == false
          return nil if table.table_row.empty?

          box = RectangleRenderer.placement_box(table, context.page_height)
          return nil unless box

          ops = []
          ops << Render::Path.save_state
          ops << render_grid(table, box)
          ops << Render::Path.restore_state
          ops.join("\n")
        end

        def self.render_grid(table, box)
          row_count = table.table_row.length
          row_height = box[:height] / row_count

          table.table_row.each_with_index.map do |row, row_index|
            render_row(row, row_index, row_count, box, row_height)
          end.join("\n")
        end
        private_class_method :render_grid

        def self.render_row(row, row_index, row_count, box, row_height)
          row_y = box[:y] + ((row_count - 1 - row_index) * row_height)
          cells = row.table_cell
          cell_count = cells.length
          cell_width = box[:width] / cell_count if cell_count.positive?

          cell_ops = cells.each_with_index.map do |cell, cell_index|
            render_cell(cell, cell_index, cell_count, box, row_y, cell_width,
                        row_height)
          end
          cell_ops.compact.join("\n")
        end
        private_class_method :render_row

        def self.render_cell(_cell, cell_index, _cell_count, box, row_y,
                             cell_width, row_height)
          return nil unless cell_width

          cell_x = box[:x] + (cell_index * cell_width)
          [
            Render::Path.rectangle(x: cell_x, y: row_y,
                                   width: cell_width,
                                   height: row_height),
            Render::Path.stroke,
          ].join("\n")
        end
        private_class_method :render_cell
      end
    end
  end
end
