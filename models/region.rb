# frozen_string_literal: true

require_relative 'dice_board'

# 1. A region has a day track with several rounds;
# 2. Each round has a corresponding search box;
# 3. Each round the player can do a search, and consume the day(s) on time
#    track;
# 4*. If all search boxes are used up, you can consume 1 day to get the
#     construct/component_type.
class Region
  attr_reader :search_boxes
  attr_reader :day_track
  attr_reader :construct, :component_type

  # @param day_track [DayTrack] Costs of each search.
  # @param construct [Construct]
  #   Find all constructs in all regions to build the Utopia Engine.
  # @param component_type [Class] Can find multiple component_types to connect constructs.
  def initialize(day_track:, construct:, component_type:)
    @day_track = day_track
    @construct = construct
    @component_type = component_type
    reset
  end

  def reset
    @search_boxes = Array.new(@day_track.size) { SearchBox.new(self) }
  end

  # @param value [Integer] The value calculated from the search box.
  # @return [Array<Construct,Component>,Nil]
  def outcome(value)
    case value
    when 0..10
      if @found_construct
        Array.new(value.zero? ? 2 : 1) { @component_type.new }
      else
        @found_construct = true
        @construct
      end
    when 11..99
      @component_type.new
    end
  end
end

# Track time spent on in the region.
class Region::DayTrack
  attr_reader :costs

  def initialize(costs)
    @costs = costs
    @size = costs.size
    @next_idx = 0
  end

  def end?
    @next_idx == @size
  end

  def next
    @costs[@next_idx].tap { @next_idx += 1 }
  end
end

# When searching,
# 1. Each time roll 2 dices, fill in to any empty spaces of the 3x2 box
# 2. Repeat for 3 times until all spaces all filled.
# 3. Now you get one 3-digit number from 1st row and one from 2nd row.
# 4. search_result = 1st-row number - 2nd row number
class Region::SearchBox < DiceBoard.new(2, 3)
  # @return [Integer,Nil] If not filled, nil; otherwise the search result.
  def result
    return @result if @result
    return unless filled?

    upper, lower = slots.map { |row| row.join('').to_i }
    @result = upper - lower
  end
end
