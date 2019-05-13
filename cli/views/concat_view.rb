# frozen_string_literal: true

class ConcatView
  def initialize(*views)
    @views = views
  end

  def to_s
    @views.map(&:to_s).join("\n")
  end
end
