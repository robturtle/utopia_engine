# frozen_string_literal: true

class DiceBoardView
  attributes :board

  def to_s
    board.slots.map(&method(:data_row)).join("\n")
  end

  private

  def data_row(row)
    '|' + row.map { |v| v || '_' }.join('|') + '|'
  end
end
