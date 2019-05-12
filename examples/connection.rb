# frozen_string_literal: true

require_relative '../bootstrap'
require_relative '../models/construct'

c1 = Construct.new('1')
c2 = Construct.new('2')
l = Connection.new(c1, c2, :wax)
l.component = Object.new.tap do |o|
  def o.type
    :wax
  end
end

l.fill 0, 1, 3
l.fill 1, 1, 3
l.col_results
