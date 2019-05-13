# frozen_string_literal: true

class BoxedView
  attributes :view

  def to_s
    lines = view.to_s.lines
    width = lines.map(&:size).max
    [
      separator(width),
      lines.map(&method(:boarded)),
      separator(width)
    ].join("\n")
  end

  private

  def separator(width)
    corner + '-' * width + corner
  end

  def boarded(line)
    '|' + line.rstrip + '|'
  end

  def corner
    '+'
  end
end
