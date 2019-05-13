# frozen_string_literal: true

class FillDiceBoardView
  def initialize(state)
    board = state.board
    pool = state.try(:pool) || DicePool.new(2).tap(&:clear!)
    basic_view = ConcatView.new(
      "\nCurrent dice board:",
      DiceBoardView.new(board),
      "\nCurrent dices",
      DicePoolView.new(pool)
    )

    case state
    when FillDiceBoard::NoDiceOnHand, FillDiceBoard::DiceOnHand
      @view = ConcatView.new(
        basic_view,
        DiceBoardKeysView.new(state)
      )
    when FillDiceBoard::NoDiceRolled
      @view = ConcatView.new(
        basic_view,
        '',
        "Press 'r' to reroll the dice!"
      )
    end
  end

  def to_s
    @view.to_s
  end
end
