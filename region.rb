# frozen_string_literal: true

# A day track represents the time consumption of a region.
# The remaining days will be subtracted by the i-th discover
# of the same region.
class DayTrack
  attr_reader :size

  def initialize(costs)
    @costs = costs
    @size = costs.size
    @current = 0
  end

  # @return [Integer]
  #   If not used up, return the cost, otherwise nil.
  def use
    raise 'DayTrack used up' if @current >= @size

    @costs[@current].tap { @current += 1 }
  end

  def reset
    @current = 0
  end
end

# When searching,
# 1. Each time roll 2 dices, fill in to any empty spaces of the 3x2 box
# 2. Repeat for 3 times until all spaces all filled.
# 3. Now you get one 3-digit number from 1st row and one from 2nd row.
# 4. search_result = 1st-row number - 2nd row number
class SearchBox
  ROWS = 2
  COLS = 3
  SLOTS = ROWS * COLS

  def initialize
    @slots = Array.new(ROWS) { Array.new(COLS) }
    @filled = 0
  end

  # @return [Array<Array<Integer>>] Available slot indexes.
  def emptys
    ROWS.product(COLS).select { |row, col| @slots[row][col].nil? }
  end

  # @return [Boolean] If successfully filled in.
  def fill(row, col, digit)
    if @slots[row][col]
      false
    else
      @filled += 1
      @slots[row][col] = digit
    end
  end

  # @return [Integer,Nil] If not filled, nil; otherwise the search result.
  def result
    return @result if @result

    if @filled == SLOTS
      upper, lower = @slots.map { |row| row.join('').to_i }
      @result = upper - lower
    end
  end
end

# 1. A region has a day track with several rounds;
# 2. Each round has a corresponding search box;
# 3. Each round the player can do a search, and consume the day(s) on time track;
# 4*. If all search boxes are used up, you can consume 1 day to get the construct/component.
class Region
  def initialize(day_track:, construct:, component:)
    @day_track = day_track
    @chances = @day_track.size
    @construct = construct
    @component = component
    reset
  end

  def reset
    @day_track.reset
    @search_boxes = Array.new(@day_track.size) { SearchBox.new }
    @next_search = 0
  end

  # @return [Array<Symbol>] The possible action(s) at the current state
  def actions
    if @searched == @chances
      @construct ? [:final_search] : []
    else
      [:search]
    end
  end

  # 1. Spent time on TimeTrack from cost on DayTrack;
  # 2. Search one search box
  # @param time_track [TimeTrack]
  # @param searcher [#search]
  # @return [Relic]
  def search(time_track, searcher)
    raise 'Normal searches used up' if @next_search == @chances

    cost = @day_track[@next_search].use
    time_track.spent(cost.days)
    searcher.search(@search_boxes[@next_search])
    case box.result
    when 0
      signal :perfect_zero, self
    when 1..10
      reward = @construct
      @construct = nil
    when 11..99
      reward = @component.new
    else
      signal :encounter, self
    end
    @next_search += 1
    reward
  end

  # @param time_track [TimeTrack]
  # @param target [Symbol] :construct or :component
  # @return [Relic]
  def final_search(time_track, target:)
    raise 'Relic already taken' unless @construct
    raise "Unknown target '#{target}'" unless %i[construct component].include?(target)

    time_track.spent(1.day)
    case target
    when :construct
      @construct.tap { @construct = nil }
    else
      @component.new
    end
  end
end
