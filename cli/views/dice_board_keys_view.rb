# frozen_string_literal: true

class DiceBoardKeysView
  def initialize(state)
    build_example(state.board)
    @board_view = DiceBoardView.new(@example)
    prompt = '^ Press the corresponding digit key to fill in the dice ^'
    @view = BoxedView.new(
      CenteredView.new(
        ConcatView.new(
          @board_view,
          '',
          "Where do you want to place the '#{state.pool.first_dice}' dice?",
          prompt
        ),
        prompt.size + 2
      )
    )
  end

  def build_example(board)
    @example = board.class.new
    i = 1
    (0...@example.rows).each do |r|
      (0...@example.cols).each do |c|
        @example.slots[r][c] = board.slots[r][c].nil? ? i : ' '
        i += 1
      end
    end
  end

  def to_s
    @view.to_s
  end
end
