require_relative '../bootstrap'

def box
  @box ||= Region::SearchBox.new
end

def action
  @action ||= Action.new(FillDiceBoard::NoDiceRolled.new(box))
end
