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
