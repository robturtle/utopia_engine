# frozen_string_literal: true

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
