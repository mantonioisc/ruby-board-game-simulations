#
# Snakes and Ladders game simulation now written in Ruby!
# I wrote the first version of this game simulator using Java and EJB3, the use of EJB3 was somewhat forced, it was just to practice such framework.
# Now I want to see how Ruby fares with a simple game like this one.
#

class Snake
	attr_reader :from, :to

	def initialize(from, to)
		raise ArgumentError, "In snakes, from #{from} must be bigger than to #{to}" if from <= to
		@from, @to = from, to
	end

	def to_s
		"Going down from #{from} to #{to}"
	end
end

class Ladder
	attr_reader :from, :to

	def initialize(from, to)
		raise ArgumentError, "In ladders, from #{from} must be less than to #{to}" if from >= to
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

	def initialize(use_brute_force, *player_names)
		@dice = Dice.new

		puts "Use brute force? #{use_brute_force}"
		algorithm = if use_brute_force then get_brute_force_algorithm else get_standard_algorithm end
		@board = generate_board &algorithm

		i = 0
		@players = player_names.map do |name|
			i += 1
			Player.new name, CHIP_COLORS[i - 1]
		end

		puts "Players ready: #{@players}"
	end

	def play
		@players.each{ |player| player.takeTurn @dice}
	end

	private

	def generate_board()
		number_of_snakes = 5
		number_of_ladders =5
		board_size = 30

		snakes, ladders = yield board_size, number_of_snakes, number_of_ladders

		Board.new snakes, ladders
	end

	def get_brute_force_algorithm()
		lambda do |board_size, number_of_snakes, number_of_ladders|
			snakes = generate_elements_by_brute_force(board_size, number_of_snakes) {|max_index| get_snake max_index }
			ladders = generate_elements_by_brute_force(board_size, number_of_ladders) {|max_index| get_ladder max_index }
			[snakes, ladders]
		end
	end

	def generate_elements_by_brute_force(board_size, number_of_elements)
		elements = []
		number_of_elements.times do
			begin
				elements << (yield board_size)
			rescue StandardError => e
				puts "Invalid element, retry.  message: #{e}"
				retry
			end
		end

		#validate no elements start at the same spot
		start_indexes = elements.map { |element| element.from }

		raise "Two elements start at the same spot! #{start_indexes}" if start_indexes.uniq != start_indexes

		elements
	rescue RuntimeError => e
		puts "Restarting elements generation: #{e}"
		elements.clear
		retry
	end

	def get_standard_algorithm()
		lambda do |board_size, number_of_snakes, number_of_ladders|
			valid_range = 2..(board_size -1)
			available_elements = valid_range.to_a.shuffle
			snakes = generate_elements(available_elements, number_of_snakes) {|from, to| from > to ? Snake.new(from, to) : Snake.new(to, from) }
			ladders = generate_elements(available_elements, number_of_ladders) {|from, to| if from < to then Ladder.new from, to else Ladder.new to, from end}
			[snakes,ladders]
		end
	end

	def generate_elements(available_elements, number_of_elements)
		elements = []

		number_of_elements.times do
			p available_elements
			first = available_elements.shift
			second = available_elements.shift
			elements << (yield first, second)
		end

		elements
	end

	def get_snake(board_size)
		random = Random.new
		from = random.rand 2..(board_size - 1)
		to = random.rand 1..(board_size - 1)
		puts "from #{from} to #{to}"
		Snake.new from, to
	end

	def get_ladder(board_size)
		random = Random.new
		from = random.rand 2..(board_size - 1)
		to = random.rand 2..(board_size - 1)
		Ladder.new from, to
	end
end


board = Game.new false, "Big Boss", "Solid Snake", "Liquid Snake", "The Boss", "Psycho Mantis"
p board
board.play
