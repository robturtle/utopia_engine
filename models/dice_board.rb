# frozen_string_literal: true

# The class template of a rectangle area which can be filled with
# dice values.
class DiceBoard
  # rubocop:disable all
  # @param rows [Integer]
  # @param cols [Integer]
  def self.new(rows, cols)
    raise 'rows must > 0' unless rows.positive?
    raise 'cols must > 0' unless cols.positive?

    clazz = Class.new do
      # @return [Array<Array<Integer>>] values of the board
      attr_reader :slots

      def initialize
        @slots = Array.new(rows) { Array.new(cols) }
      end

      # @param row [Integer] 0 <= row < rows
      # @param col [Integer] 0 <= col < cols
      # @param value [Integer] the dice value
      def fill(row, col, value)
        unless row >= 0 && row < rows && col >= 0 && col < cols
          raise "Index out of bound! (row: #{row}, col: #{col})"
        end
        raise 'Slot already filled!' if @slots[row][col]

        slots[row][col] = value
      end

      def reset
        @slots = Array.new(rows) { Array.new(cols) }
      end

      # @return [Array<Tuple<Integer,Integer>>]
      #   The list of (row,col) with empty slot.
      def emptys
        [*0...rows].product([*0...cols]).select { |r, c| slots[r][c].nil? }
      end

      def filled?
        emptys.empty?
      end

      # <===== 1-dimentional indexing supports
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
        unless idx >= 0 && idx < slot_size
          raise "Index out fo bound! (idx: #{idx})"
        end

        fill(*from_idx(idx), value)
      end

      # @return [Array<Integer>] The indexes of empty slots
      def empty_indexes
        emptys.map { |r, c| idx(r, c) }
      end
      # =====> 1-dimentional indexing supports
    end
    clazz.class_eval "def rows; #{rows}; end", __FILE__, __LINE__
    clazz.class_eval "def cols; #{cols}; end", __FILE__, __LINE__
    clazz.class_eval "def slot_size; #{rows * cols}; end", __FILE__, __LINE__
    clazz
  end
  # rubocop:enable all
end
