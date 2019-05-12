# frozen_string_literal: true

require_relative '../models/dice'

module FillDiceBoard
  class NoDiceRolled < State
    DICE_NUM = 2

    attributes :board

    action :roll_dices, -> { NoDiceOnHand.new(@pool, board) }

    def roll_dices
      @pool = DicePool.new(DICE_NUM)
    end
  end

  class NoDiceOnHand < State
    attributes :pool, :board

    action :pick_dice,
           -> { DiceOnHand.new(@dice, @pool, @board) },
           -> { pool.availables }

    def pick_dice(idx)
      @dice = pool.take(idx)
    end
  end

  class DiceOnHand < State
    attributes :dice, :pool, :board

    action :fill_board, :new_state, -> { board.empty_indexes }

    def fill_board(idx)
      board.fill_idx(idx, dice)
    end

    def new_state
      if pool.empty?
        NoDiceRolled.new(board)
      elsif board.filled?
        nil
      else
        NoDiceOnHand.new(pool, board)
      end
    end
  end
end
