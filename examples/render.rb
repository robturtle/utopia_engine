require_relative '../bootstrap'

def box
  @box ||= Region::SearchBox.new
end

def pool
  @pool ||= DicePool.new(2)
end

def v
  @v ||= DiceBoardView.new(box)
end

def w
  @w ||= DicePoolView.new(pool)
end

def b
  @b ||= BoxedView.new(v)
end
