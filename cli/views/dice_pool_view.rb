# frozen_string_literal: true

class DicePoolView
  class Adaptor
    attributes :pool

    def slots
      [pool.results]
    end
  end

  def initialize(pool)
    @view = DiceBoardView.new(Adaptor.new(pool))
  end

  def to_s
    @view.to_s
  end
end
