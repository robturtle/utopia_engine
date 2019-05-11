# frozen_string_literal: true

require_relative 'dice_board'

# When searching,
# 1. Each time roll 2 dices, fill in to any empty spaces of the 3x2 box
# 2. Repeat for 3 times until all spaces all filled.
# 3. Now you get one 3-digit number from 1st row and one from 2nd row.
# 4. search_result = 1st-row number - 2nd row number
class SearchBox < DiceBoard.new(2, 3)
  attr_reader :region

  def initialize(region)
    super()
    @region = region
  end

  # @return [Integer,Nil] If not filled, nil; otherwise the search result.
  def result
    return @result if @result

    if filled?
      upper, lower = slots.map { |row| row.join('').to_i }
      @result = upper - lower
    end
  end
end

# 1. A region has a day track with several rounds;
# 2. Each round has a corresponding search box;
# 3. Each round the player can do a search, and consume the day(s) on time track;
# 4*. If all search boxes are used up, you can consume 1 day to get the construct/component.
class Region
  attr_reader :search_boxes
  attr_reader :tries, :day_track
  attr_reader :construct, :component

  attr_reader :found_construct
  alias found_construct? found_construct

  # @param day_track [Array<Integer>] Costs of each search.
  # @param construct [Construct]
  #   Find all constructs in all regions to build the Utopia Engine.
  # @param component [Class] Can find multiple components to connect constructs.
  def initialize(day_track:, construct:, component:)
    @day_track = day_track
    @construct = construct
    @component = component
    @found_construct = false
    reset
  end

  def reset
    @search_boxes = Array.new(@day_track.size) { SearchBox.new(self) }
    @tries = 0
  end

  def search
    raise 'Chances used up' if @tries == @day_track.size

    yield @search_boxes[@tries]
    @tries += 1
  end

  # @param reward [Symbol] :construct or :component
  # @return [Construct,Component]
  def final_search(reward:)
    case reward
    when :construct
      @construct.tap { construct_found }
    when :component
      @component.new
    else
      raise "Unknown reward '#{reward}'"
    end
  end

  def construct_found
    raise 'Construct already found!' if @found_construct

    @found_construct = true
    signal :found_construct, region: self
  end

  # @param value [Integer] The value calculated from the search box.
  # @return [Array<Construct,Component>,Nil]
  def outcome(value)
    case value
    when 0..10
      signal :perfect_zero, region: self if value == 0
      if @found_construct
        reward = Array.new(value == 0 ? 2 : 1) { @component.new }
      else
        construct_found
        reward = @construct
      end
    when 11..99
      reward = @component.new
    else
      signal :encounter, region: self, value: value
    end
    reward
  end
end
