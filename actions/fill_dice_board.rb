# frozen_string_literal: true

# The action of filling the dice board.
#
# The board could be a SearchBox, a Activation, or a Connection.
# 1. Each round it will generate a new DicePool.
# 2. Each step in a round one should use one dice value from the
#    dice pool to fill the dice board.
# 3. A round completed if board filled or dice pool used up.
# 4. The action compleeted if board filled.
module FillDiceBoard
  NoDiceOnHand = Struct.new(:pool, :board) do
    POOL_SIZE = 2

    PARAMS = {
      pick_dice: -> { pool.availables }
    }.freeze

    def actions
      if pool.empty?
        [:new_dice_pool]
      else
        [:pick_dice]
      end
    end

    def new_dice_pool
      self.pool = DicePool.new(POOL_SIZE)
      self
    end

    def pick_dice(idx)
      DiceOnHand.new(pool.take(idx), pool, board)
    end
  end

  DiceOnHand = Struct.new(:hand, :pool, :board) do
    PARAMS = {
      fill_dice: -> { board.empty_indexes }
    }.freeze

    def actions
      [:fill_dice]
    end

    def fill_dice(idx)
      board.fill_idx(idx, hand)
      if board.filled?
        BoardCompleted.new(board)
      else
        NoDiceOnHand.new(pool, board)
      end
    end
  end

  BoardCompleted = Struct.new(:board) do
    def actions
      [:return]
    end

    def return
      signal :fill_board_completed, board: board
    end
  end
end
