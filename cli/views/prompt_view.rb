# frozen_string_literal: true

class PromptView
  attributes :prompt

  def to_s
    prompt.lines.join("\n")
  end
end
