# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Table. Draws the cell grid via rectangle ops,
      # then renders inline `<CharacterStyleRange>` text in each cell
      # via `canvas.text_rich`. Cells with no text render as empty
      # rectangles.
      class TableRenderer
        DEFAULT_SIZE = 10.0
        INSET = 4.0

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
              render_row(canvas, row, row_index, row_count, box, row_height,
                         context)
            end
          end
        end

        def self.render_row(canvas, row, row_index, row_count, box, row_height,
                            context)
          row_y = box[:y] + ((row_count - 1 - row_index) * row_height)
          cell_count = row.table_cell.length
          return unless cell_count.positive?

          cell_width = box[:width] / cell_count
          row.table_cell.each_with_index do |cell, cell_index|
            cell_x = box[:x] + (cell_index * cell_width)
            canvas.rectangle(cell_x, row_y, cell_width, row_height)
            canvas.stroke
            render_cell_text(canvas, cell, cell_x, row_y, row_height, context)
          end
        end
        private_class_method :render_row

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
      end
    end
  end
end
