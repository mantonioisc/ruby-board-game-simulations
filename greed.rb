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
	attr_reader :name

	def initialize(name)
		@name = name
	end

	def take_turn(dice_set, dice_number = NUMBER_OF_DICE)
		dice_set.roll dice_number #1 liner I know, but the player should be allowed to throw the dices by himself
	end

	def keep_rolling? turn_score, non_scoring_dices
		return false if non_scoring_dices == 0
		if turn_score > MINIMUM_SCORE
			keep = rand(0..1) == 0 #Let him decide randomly if we wants to play
			puts "#{@name} is taking his #{turn_score} points" unless keep
			keep
		else
			true
		end
	end

	def to_s
		@name
	end
end

class GreedGame
	attr_reader :players

	def initialize(*player_names)
		@dice_set = DiceSet.new
		@players = Hash[player_names.map{|name| [Player.new(name), 0]}] #Keep players and their score in a hash
	end

	def play
		puts "These people is playing Greed: #{@players.keys}"
		until @players.max_by{|player, score| score}[1] >= MAXIMUM_SCORE
			@players.each do |player, score|
				@players[player] = let_player_roll player, score
			end
			puts "===Global scores #{@players}==="
		end
		winner = @players.max_by{|player, score| score}[0]
		puts "_\\|/_The winner is #{winner.name}!_\\|/_"
		winner
	end

	private
	def let_player_roll(player, total_score)
		puts "=>Is #{player.name}'s turn<="
		turn_score, dice_number = 0, NUMBER_OF_DICE
		player.take_turn @dice_set, dice_number #Lend the player the dice set to roll, the player should not use his own dices in real life
		score, non_scoring_dices = calculate_score @dice_set.values
		turn_score += score
		loop do
			if non_scoring_dices == dice_number
				puts "#{player.name} lost #{turn_score} by greed"
				raise StopIteration
			elsif player.keep_rolling? turn_score, non_scoring_dices #Ask the player if he wants to continue
				dice_number = non_scoring_dices
				player.take_turn @dice_set, dice_number #tell the player how many dice to roll this time
				score, non_scoring_dices = calculate_score @dice_set.values
				turn_score += score
			else
				if total_score >= MINIMUM_SCORE || turn_score >= MINIMUM_SCORE
					total_score += turn_score
				end
				puts "#{player.name} got #{turn_score} and has a total of: #{total_score}"
				raise StopIteration
			end
		end
		total_score
	end

	def calculate_score(dice_values)
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
				zero_counter += (count-3)
				100*dice_value
			else
				zero_counter += count
				0
			end
		end
		[result, zero_counter]
	end
end

game = GreedGame.new "Cat", "Dog", "Mouse", "OctoCat"
game.play
