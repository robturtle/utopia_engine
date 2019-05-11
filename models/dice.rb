# frozen_string_literal: true

require 'securerandom'

# Provide random numbers
class Dice
  def initialize(range: 1..6, random: SecureRandom)
    @range = range
    @random = random
  end

  def roll
    @random.rand(@range)
  end
end

class DicePool
  # @return [Array<Integer>]
  attr_reader :results

  def initialize(capacity, dice: Dice.new)
    @capacity = capacity
    @results = Array.new(capacity) { dice.roll }
  end

  # @return [void] Yield the result if present, otherwise do nothing.
  def use(index)
    raise 'Invalid index of dice pool' if index < 0 || index >= @capacity
    raise 'The result already been taken' if @results[index].nil?

    if (result = @results[index])
      yield result
      @results[index] = nil
    end
  end
end
