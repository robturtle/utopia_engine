# frozen_string_literal: true

# Added readability unit annotations.
class Integer
  alias day itself
end

# A mock of event system.
class Object
  def self.attributes(*attrs)
    attr_reader(*attrs)
    define_method(:initialize) do |*args|
      attrs.zip(args).each do |atr, arg|
        instance_variable_set("@#{atr}", arg)
      end
    end
  end

  def try(name, *args)
    send(name, *args) if respond_to?(name)
  end

  def signal(message, *args)
    args = args.map do |a|
      case a
      when Hash
        a.transform_values(&:class)
      else
        a.class
      end
    end
    puts "SIGNAL: #{message}(#{args.join(', ')})"
    nil
  end

  def on(message); end

  def require_all(path)
    Dir["./#{path}/*.rb"].each { |f| require_relative f }
  end
end
