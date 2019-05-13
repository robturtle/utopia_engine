require_relative '../bootstrap'

def box
  @box ||= Region::SearchBox.new.tap { |b| b.fill_idx(1, 3) }
end

def pool
  @pool ||= DicePool.new(2)
end

def on_hand
  @on_hand ||= FillDiceBoard::NoDiceOnHand.new(pool, box)
end

def no_dice
  @no_dice ||= FillDiceBoard::NoDiceRolled.new(box)
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

def view1
  FillDiceBoardView.new(on_hand)
end

def view2
  FillDiceBoardView.new(no_dice)
end
