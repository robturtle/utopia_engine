# frozen_string_literal: true

class KeyBinddings
  on :state_change, -> { @state = new_state }

  # @param state [State]
  def initialize(state)
    @state = state
  end

  def all_binddings
    @state.all_states.map { |s| s.try(:key_bindings) }.compact.flatten
  end
end

module KeyBinddings::Binder
  def key_bindings
    @key_bindings ||= []
  end

  def bind_key(key, action)
    key_bindings << [key.to_s, action]
  end
end
