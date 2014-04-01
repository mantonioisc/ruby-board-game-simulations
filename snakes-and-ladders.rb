#
# Snakes and Ladders game simulation now written in Ruby!
# I wrote the first version of this game simulator using Java and EJB3, the use of EJB3 was somewhat forced, it was just to practice such framework.
# Now I want to see how Ruby fares with a simple game like this one.
#

class Snake
	attr_accessor :from, :to

	def initialize(from, to)
		raise ArgumentError, "In snakes, from must be bigger than to" if from <= to
		@from, @to = from, to
	end

	def to_s
		"Going down from #{from} to #{to}"
	end
end

class Ladder
	attr_accessor :from, :to

	def initialize(from, to)
		raise ArgumentError, "In ladders, from must be less than to" if from >= to
		@from, @to = from, to
	end

	def to_s
		"Going Up! from #{from} to #{to}"
	end
end

class Dice

end

class Board

end

class Player
	attr_accessor :name, :dice

end

class Game

end


snake = Snake.new 10, 5
ladder = Ladder.new 15, 20

puts snake
puts ladder
