# frozen_string_literal: true

class DiceBoardKeysView
  def initialize(board)
    @example = board.class.new
    i = 1
    (0...@example.rows).each do |r|
      (0...@example.cols).each do |c|
        @example.slots[r][c] = i
        i += 1
      end
    end
    @board_view = DiceBoardView.new(@example)
    prompt = "\n^ Press the corresponding digit key to fill in the dice ^"
    @view = BoxedView.new(
      CenteredView.new(
        ConcatView.new(
          @board_view,
          prompt
        ),
        prompt.size + 2
      )
    )
  end

  def to_s
    @view.to_s
  end
end
