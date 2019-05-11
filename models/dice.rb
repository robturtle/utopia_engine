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

# In the same round the player will roll multiple dices at once,
# and use the results in multiple steps.
class DicePool
  # @return [Array<Integer>]
  attr_reader :results

  def initialize(capacity, dice: Dice.new)
    @capacity = capacity
    @results = Array.new(capacity) { dice.roll }
  end

  # @return [void] Yield the result if present, otherwise do nothing.
  def take(index)
    raise 'Invalid index of dice pool' if index.negative? || index >= @capacity
    raise 'The result already been taken' if @results[index].nil?

    @results[index].tap { @results[index] = nil }
  end

  def availables
    (0...@capacity).select { |i| @results[i] }
  end

  def empty?
    availables.empty?
  end
end
