# frozen_string_literal: true

require_relative 'dice_board'

# 1. You should activate the construct to build the Utopia Engine;
class Construct
  attr_reader :name, :activation

  def initialize(name, activated: false)
    @name = name
    @activated = activated
    @activation = Activation.new(self)
  end

  def activated?
    return @activated if @activated

    @activated = true if @activation.energy >= @activation.shreshold
    false
  end
end

# 1. Each Construct has one Activation
# 2. Each Activation has two channels
# 3. Each channel can be used once to generate engergy
# 4. If sum of engery from all channels >= the threshold,
#    activation succeeded
# 5. All exceeded energy will be saved to Hand of God
# 6. If sum of engery from all channels < the threshold,
#    can spent 1 day to force activate
class Construct::Activation
  CHANNEL_NUM = 2
  ACTIVATE_SHRESHOLD = 4

  attr_reader :construct, :channels, :shreshold

  # @param construct [Construct]
  # @param channel_num [Integer] Default to CHANNEL_NUM
  # @param activate_shreshold [Integer] Default to ACTIVATE_SHRESHOLD
  def initialize(construct, channel_num: CHANNEL_NUM, activate_shreshold: ACTIVATE_SHRESHOLD)
    @construct = construct
    @channels = Array.new(channel_num) { Channel.new(self) }
    @shreshold = activate_shreshold
  end

  def energy
    @channels.map(&:col_results).flatten.compact.reduce(0, &:+)
  end
end

# Count the result column by column (diff = upper value - lower value);
class Construct::Activation::Channel < DiceBoard.new(2, 4)
  attr_reader :activation

  def initialize(activation)
    super()
    @activation = activation
  end

  def fill(row, col, value)
    super
    if slots[0][col] == slots[1][col]
      slots[0][col] = slots[1][col] = nil
      signal :channel_cancel_zero, channel: self
    end
  end

  # @param col [Integer]
  # @return [Integer]
  def col_result(col)
    @col_results ||= Array.new(cols)
    return @col_results[col] if @col_results[col]
    return nil unless slots[0][col] && slots[1][col]

    @col_results[col] =
      case (diff = slots[0][col] - slots[1][col])
      when 5
        2
      when 4
        1
      else
        signal :channel_activate_damage, channel: self if diff < 0
        0
      end
  end

  # @return [Array<Integer>] Value of results
  def col_results
    (0...cols).map(&method(:col_result))
  end
end
