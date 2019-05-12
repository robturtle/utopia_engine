# frozen_string_literal: true

require_relative 'construct'
require_relative 'player'
require_relative 'region'

class Game
  COMPONENT_TYPES = [
  ].freeze

  CONSTRUCTS = [
  ].freeze

  REGIONS = [
  ].freeze

  def initialize
    @regions = REGIONS
    @found_constructs = []
    @components = Hash.new(0)
  end
end
