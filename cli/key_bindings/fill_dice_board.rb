# frozen_string_literal: true

module FillDiceBoard
  class NoDiceOnHand
    include KeyBinddings::Binder

    def key_bindings
      domain(:pick_dice).each do |idx|
        bind_key idx, -> { action.run(:pick_dice, idx) }
      end
    end
  end

  class DiceOnHand
    include KeyBinddings::Binder

    def key_bindings
      domain(:fill_board).each do |idx|
        bind_key idx, -> { action.run(:fill_board, idx) }
      end
    end
  end
end
