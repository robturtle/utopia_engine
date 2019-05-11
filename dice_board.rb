# frozen_string_literal: true

# The class template of a rectangle area which can be filled with
# dice values.
class DiceBoard
  # @param rows [Integer]
  # @param cols [Integer]
  def self.new(rows, cols)
    raise 'rows must > 0' unless rows > 0
    raise 'cols must > 0' unless cols > 0

    board_class = Class.new do
      # @return [Array<Array<Integer>>] values of the board
      attr_reader :slots

      def initialize
        @slots = Array.new(rows) { Array.new(cols) }
      end

      # @param row [Integer] 0 <= row < rows
      # @param col [Integer] 0 <= col < cols
      # @param value [Integer] the dice value
      def fill(row, col, value)
        raise "Index out of bound! (row: #{row}, col: #{col})" unless row >= 0 && row < rows && col >= 0 && col < cols
        raise 'Slot already filled!' if @slots[row][col]

        slots[row][col] = value
      end

      # @return [Array<Tuple<Integer,Integer>>] The list of (row,col) with empty slot.
      def emptys
        [*0...rows].product([*0...cols]).select { |r, c| slots[r][c].nil? }
      end

      def filled?
        emptys.empty?
      end

      # ===== 1-dimentional indexing supports
      # This is for the convenient of CLI UI so the human player
      # can input a single number to fill in the dice value.

      # @return [Integer] to 1-dimentinoal coordinate
      def idx(row, col)
        row * cols + col
      end

      # @param [Integer] The 1-dimentional coordinate
      # @return [Tuple<Integer, Integer>] row and col
      def from_idx(idx)
        [idx / cols, idx % cols]
      end

      # @param idx [Integer] The 1-dimentional coordindate
      # @param value [Integer] the dice value
      def fill_idx(idx, value)
        raise "Index out fo bound! (idx: #{idx})" unless idx >= 0 && idx < slot_size

        fill(*from_idx(idx), value)
      end

      # @return [Array<Integer>] The indexes of empty slots
      def empty_indexes
        emptys.map { |r, c| idx(r, c) }
      end
    end
    board_class.class_eval "def rows; #{rows}; end"
    board_class.class_eval "def cols; #{cols}; end"
    board_class.class_eval "def slot_size; #{rows * cols}; end"
    board_class
  end
end