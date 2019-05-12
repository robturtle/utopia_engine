# frozen_string_literal: true

require_relative '../actions/state'
require_relative '../actions/action'

class FillSlots < State
  describe do
    action :fill_slot, :show_slots, -> { availables }
  end

  attr_accessor :slots

  def initialize(slots = nil)
    self.slots = slots || Array.new(6)
  end

  def availables
    (0...6).select { |i| slots[i].nil? }
  end

  def fill_slot(i)
    puts "Put X into #{i}"
    slots[i] = 'X'
  end

  def show_slots
    ShowSlots.new(slots)
  end
end

class ShowSlots < State
  describe do
    action :show, -> { FillSlots.new(slots) }
  end

  attr_reader :slots

  def initialize(slots)
    @slots = slots
  end

  def show
    puts slots.map { |v| v || '_' }.join('|')
  end
end

def a
  @a ||= Action.new(FillSlots.new)
end
