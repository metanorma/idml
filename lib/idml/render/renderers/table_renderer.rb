# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      class TableRenderer
        def self.render(canvas, context)
          table = context.item
          return if table.visible == false
          return if table.table_row.empty?

          box = Placement.box(table, context.page_height)
          return unless box

          row_count = table.table_row.length
          row_height = box[:height] / row_count

          canvas.save_graphics_state do
            table.table_row.each_with_index do |row, row_index|
              render_row(canvas, row, row_index, row_count, box, row_height)
            end
          end
        end

        def self.render_row(canvas, row, row_index, row_count, box, row_height)
          row_y = box[:y] + ((row_count - 1 - row_index) * row_height)
          cell_count = row.table_cell.length
          return unless cell_count.positive?

          cell_width = box[:width] / cell_count
          row.table_cell.each_with_index do |_cell, cell_index|
            cell_x = box[:x] + (cell_index * cell_width)
            canvas.rectangle(cell_x, row_y, cell_width, row_height)
            canvas.stroke
          end
        end
        private_class_method :render_row
      end
    end
  end
end
