#
# Snakes and Ladders game simulation now written in Ruby!
# I wrote the first version of this game simulator using Java and EJB3, the use of EJB3 was somewhat forced, it was just to practice such framework.
# Now I want to see how Ruby fares with a simple game like this one.
#

class Snake
	attr_reader :from, :to

	def initialize(from, to)
		raise ArgumentError, "In snakes, from must be bigger than to" if from <= to
		@from, @to = from, to
	end

	def to_s
		"Going down from #{from} to #{to}"
	end
end

class Ladder
	attr_reader :from, :to

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

class Board
	attr_reader :snakes, :ladders, :rows, :cols

	def initialize(snakes, ladders, rows = 6, cols = 5)
		@snakes, @ladders, @rows, @cols = snakes, ladders, rows, cols
		@size = @rows * @cols
	end

	def check_box(current_position, advance_positions)
		next_position = current_position + advance_positions

		if next_position > @size
			puts "Current position + dice result is bigger than board size, bouncing back from end!"
			next_position = current_position + (next_position - @size)
		end

		tentative_next_position = next_position

		snakes.each do |snake|
			if snake.from == next_position
				puts snake
				next_position = snake.to
			end
		end

		ladders.each do |ladder|
			if ladder.from == next_position
				puts ladder
				next_position = ladder.to
			end
		end

		puts "Current position #{current_position}, tentative #{tentative_next_position} and true next position #{next_position}"

		next_position
	end
end

class Player
	attr_reader :name, :chip

	def initialize(name, chip)
		@name, @chip = name, chip
	end

	def takeTurn(dice)
		advance_positions = dice.throw
		puts "Player #{@chip}:#{@name} advances #{advance_positions}"
		advance_positions
	end
end

class Game
	CHIP_COLORS = [:blue, :red, :purple, :white, :green, :yellow]

	def initialize( *player_names )
		@dice = Dice.new
		@board = generate_board
		i = 0
		@players = player_names.map do |name|
			i += 1
			Player.new name, CHIP_COLORS[i - 1]
		end
	end

	def play
		@players.each{ |player| player.takeTurn @dice}
	end

	private
	def generate_board()
		# TODO create this randomly
		snakes = [Snake.new(6, 1), Snake.new(10, 5), Snake.new(29, 20)]
		ladders = [Ladder.new(11, 16), Ladder.new(21, 26), Ladder.new(18, 23)]

		Board.new snakes, ladders
	end
end


board = Game.new "Big Boss", "Solid Snake", "Liquid Snake", "The Boss", "Psycho Mantis"
p board
board.play
