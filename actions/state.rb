# frozen_string_literal: true

# Use state machine to represent game state so as to:
#
# 1. Limit the possible operations in the state instead of allow all but
#    check the precondition everytime;
# 2. Separate the control flow from other logic to make it easy to maintain
#    and change.
class State
  # As a domain, TOTAL includes everything
  TOTAL_SET = Object.new.tap do |o|
    def o.include?(_)
      true
    end
  end

  Entry = Struct.new(:state, :domain)

  class << self
    alias describe class_exec

    # @return [Hash<Symbol,Entry>] Maps action_name to its domain & next state
    def actions
      @actions ||= {}
    end

    def action(name, state, domain = [])
      actions[name] = Entry.new(state, domain)
    end
  end

  # Chain states in a tree structure
  # @return [State]
  attr_accessor :parent_state

  # @return [Hash<Symbol,Entry>] Maps action_name to its domain & next state.
  def actions
    self.class.actions
  end

  # @return [Array<Symbol>] All possible action names.
  def action_names
    actions.keys
  end

  # @return [State] Make the action, return the next state
  def transform(action_name, input = nil)
    range = domain(action_name)
    if range.empty?
      send(action_name)
    elsif !range.include?(input)
      raise "Input (#{input}) out of domain (#{range})!"
    else
      send(action_name, input)
    end
    next_state(action_name)
  end

  # @return [State] next state
  def next_state(action_name)
    unless actions.key?(action_name)
      raise "Cannot find the action '#{action_name}'"
    end

    state = extract(actions[action_name].state)
    raise 'No parent state to return!' if state.nil? && parent_state.nil?

    case state
    when Symbol
      send(state)
    when nil
      parent_state
    else
      state
    end
  end

  # @return [Array[State]] Current state hierarchy.
  def all_states
    states = []
    state = self
    loop do
      states << state
      state = state.parent_state
      return states unless state
    end
  end

  # @return [Enumerable] The enumeration of the domain.
  def domain(action_name)
    unless actions.key?(action_name)
      raise "Cannot find the action '#{action_name}'"
    end

    domain = extract(actions[action_name].domain)
    case domain
    when Symbol
      send(domain)
    when nil
      []
    else
      domain
    end
  end

  private

  def extract(func_or_val)
    func_or_val.respond_to?(:call) ? instance_exec(&func_or_val) : func_or_val
  end
end
