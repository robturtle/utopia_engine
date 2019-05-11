# frozen_string_literal: true

# Added readability unit annotations.
class Integer
  alias day itself
end

# A mock of event system.
class Object
  def signal(message, *args)
    puts "SIGNAL: #{message}(#{args.join(', ')})"
    nil
  end

  def on(message); end
end
