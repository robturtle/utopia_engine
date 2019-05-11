# frozen_string_literal: true

class Integer
  alias day itself
end

class Object
  def signal(message, *args)
    puts "SIGNAL: #{message}(#{args.join(', ')})"
    nil
  end

  def on(message); end
end
