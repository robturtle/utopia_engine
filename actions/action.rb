# frozen_string_literal: true

require_relative 'state'

class Action
  class NoActionSelected < State
    action :choose_action, :action_selected, -> { state.action_names }

    attr_reader :state

    def initialize(state)
      @state = state
    end

    def choose_action(action)
      @action = action
    end

    def action_selected
      ActionSelected.new(@state, @action)
    end
  end

  class ActionSelected < State
    action :take_input, :input_taken, -> { state.domain(@action) }

    attr_reader :state

    def initialize(state, action)
      @state = state
      @action = action
    end

    def take_input(input = nil)
      @input = input
    end

    def input_taken
      InputTaken.new(@state, @action, @input)
    end
  end

  class InputTaken < State
    action :act, -> { NoActionSelected.new(@new_state) }

    attr_reader :state

    def initialize(state, action, input)
      @state = state
      @action = action
      @input = input
    end

    def act
      @new_state = @state.transform(@action, @input)
    end
  end

  attr_reader :meta_state

  def initialize(state)
    @meta_state = NoActionSelected.new(state)
  end

  def state
    @meta_state.state
  end

  def action_names
    @meta_state.domain(:choose_action)
  end

  def domain
    @meta_state.domain(:take_input)
  end

  def action=(action)
    @meta_state = @meta_state.transform(:choose_action, action)
  end

  def input=(input)
    @meta_state = @meta_state.transform(:take_input, input)
  end

  def act
    old_state = state
    @meta_state = @meta_state.transform(:act)
    signal :state_change, from: old_state, to: state
  end

  def act_with_input(input = nil)
    self.input = input
    act
  end

  def run(action, input = nil)
    self.action = action
    self.input = input
    act
  end
end
