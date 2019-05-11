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

  def available_source
    @pool.availables
  end

  def available_dests
    @dice_board.empty_indexes
  end

  def fill(from:, to:)
    raise 'Illegal source index!' unless available_source.include?(from)
    raise 'Illegal destination index!' unless available_dests.include?(to)

    @pool.use(from) { |value| @dice_board.fill_idx(to, value) }
    signal :dice_fill, filler: self, from: from, to: to
    signal :dices_used_up, filler: self if @pool.empty?
    signal :board_completed, board: @dice_board if @dice_board.filled?
  end
end
