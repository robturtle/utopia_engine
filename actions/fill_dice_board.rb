# frozen_string_literal: true

# The action of filling the dice board.
#
# The board could be a SearchBox, a Activation, or a Connection.
# 1. Each round it will generate a new DicePool.
# 2. Each step in a round one should use one dice value from the
#    dice pool to fill the dice board.
# 3. A round completed if board filled or dice pool used up.
# 4. The action compleeted if board filled.
class FillDiceBoard
  POOL_SIZE = 2

  # @param dice_board [DiceBoard]
  def initialize(dice_board)
    @dice_board = dice_board
    new_dice_pool
  end

  def new_dice_pool
    raise 'Still has not used dice!' if @pool && !@pool.empty?

    @pool = DicePool.new(POOL_SIZE)
    signal :new_dice_pool
  end

  def pick_dice(idx)
    raise 'Illegal dice index!' unless available_source.include?(idx)
    raise 'Already one dice on the hand!' if @dice

    @dice = @pool.take(idx)
  end

  def fill(idx)
    raise 'No dice on the hand!' unless @dice
    raise 'Illegal board index!' unless available_dests.include?(idx)

    @dice_board.fill_idx(idx, @dice)
    signal :dice_fill, filler: self, value: @dice, to: idx
    signal :board_completed, board: @dice_board if @dice_board.filled?
    signal :dices_used_up, filler: self if @pool.empty?
    @dice = nil
  end

  def available_source
    @pool.availables
  end

  def available_dests
    @dice_board.empty_indexes
  end
end
