require_relative '../bootstrap'

class Foo
  attributes :a, :b, :c
end

foo = Foo.new(1, 2, 3)
puts [foo.a, foo.b, foo.c]