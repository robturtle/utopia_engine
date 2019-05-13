# frozen_string_literal: true

class BoxedView
  attributes :view

  def to_s
    lines = view.to_s.lines
    @width = lines.map(&:size).max
    [
      separator,
      lines.map(&method(:boarded)),
      separator
    ].join("\n")
  end

  private

  def separator
    corner + '-' * @width + corner
  end

  def boarded(line)
    l = line.rstrip
    '|' + l + ' ' * (@width - l.size) + '|'
  end

  def corner
    '+'
  end
end
