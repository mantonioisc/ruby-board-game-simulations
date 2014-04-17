# Greed game implementation [https://en.wikipedia.org/wiki/Greed_(dice_game)]
# I did it because it was suggested by Ruby koans (http://rubykoans.com/) about_extra_credit.rb
MINIMUM_SCORE = 300
MAXIMUM_SCORE = 3000
NUMBER_OF_DICE = 5

class DiceSet
	attr_accessor :values

	def roll(number)
		@values = number.times.inject([]){|a| a << rand(1..6)}
		puts "Dice roll(#{number}): #{@values}"
	end
end

class Player
	attr_reader :name, :score

	def initialize(name, rules_proc)
		@name = name
		@score = 0
		@rules = rules_proc #yeah you could say each player can cheat by playing by their own rules of scoring
	end

	def take_turn(dice_set, dice_number = NUMBER_OF_DICE)
		puts "=>Is #{@name}'s turn<="
		dice_set.roll dice_number
		sum = 0
		score, non_scoring_dices = @rules.call dice_set.values
		sum += score
		loop do
			if non_scoring_dices == dice_number
				puts "#{@name} lost #{sum} by greed"
				raise StopIteration
			elsif keep_rolling? non_scoring_dices
				dice_number = non_scoring_dices
				dice_set.roll dice_number
				score, non_scoring_dices = @rules.call dice_set.values
				sum += score
			else
				check_and_set_score sum
				raise StopIteration
			end
		end
	end

	private
	def keep_rolling? non_scoring_dices
		#puts "Non scoring dices #{non_scoring_dices}"
		return true if non_scoring_dices != 0
		false #just play once for now
	end

	def check_and_set_score(score)
		if @score >= MINIMUM_SCORE || score >= MINIMUM_SCORE
			@score += score
		end
		puts "#{@name} got #{score} and has a total of: #{@score}"
	end
end

class GreedGame
	def initialize(*player_names)
		@dice_set = DiceSet.new
		rules_proc = get_scoring_procedure
		#Play the game by my rules! and don't cheat
		@players = player_names.map{|name| Player.new name, rules_proc}
	end

	def play
		puts "This people is playing Greed: #{@players}"
		scores = [0]
		until scores.max >= MAXIMUM_SCORE
			scores = @players.map {|player| player.take_turn @dice_set; player.score }
			puts "===Global scores #{scores}==="
		end
		winner = @players.max_by {|player| player.score}
		puts "_\\|/_The winner is #{winner.name}!_\\|/_"
	end

	private
	def get_scoring_procedure
		lambda do |dice_values|
			zero_counter = 0
			result = dice_values.inject(Hash.new 0){|points, d| points[d]+=1; points}.inject(0) do |sum, (dice_value, count)|
				sum += if dice_value == 1 && count >= 3
					1000 + 100*(count-3)
				elsif dice_value == 1 && count < 3
					100*count
				elsif dice_value == 5 && count >= 3
					500 + 50*(count-3)
				elsif dice_value == 5 && count < 3
					50*count
				elsif count >= 3
					100*dice_value
				else
					zero_counter += count
					0
				end
			end
			[result, zero_counter]
		end
	end
end

game = GreedGame.new "Cat", "Dog", "Mouse"
game.play
