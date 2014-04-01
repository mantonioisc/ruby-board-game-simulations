#
# Snakes and Ladders game simulation now written in Ruby!
# I wrote the first version of this game simulator using Java and EJB3, the use of EJB3 was somewhat forced, it was just to practice such framework.
# Now I want to see how Ruby fares with a simple game like this one.
#

CHIP_COLORS = [:blue, :red, :green, :white, :purple]

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
	def initialize
		@random = Random.new
	end

	def throw()
		@random.rand(1..6)
	end

	def throwTwice()
		@random.rand(1..12)
	end
end

DICE = Dice.new

class Board
	attr_accessor :snakes, :ladders
end

class Player
	attr_accessor :name, :chip, :dice

	def initialize(name, chip, dice = DICE)
		@name, @chip, @dice = name, chip, dice
	end

	def takeTurn()
		advance_positions = @dice.throw
		puts "Player #{@name}:#{@chip} advances #{advance_positions}"
		advance_positions
	end
end

class Game

end


snake = Snake.new 10, 5
ladder = Ladder.new 15, 20
dice = Dice.new
player = Player.new "Solid Snake", :blue

puts snake
puts ladder
puts dice.throw
puts dice.throwTwice
puts DICE.throw
player.takeTurn
