# frozen_string_literal: true

class CenteredView
  def initialize(view, width)
    @view = view
    @width = width
  end

  def to_s
    @view.to_s.lines.map(&method(:pad_both)).join("\n")
  end

  private

  def pad_both(line)
    line = line.rstrip
    total = @width - line.size
    if total.negative?
      line
    else
      ' ' * (left = total / 2) + line + ' ' * (total - left)
    end
  end
end
