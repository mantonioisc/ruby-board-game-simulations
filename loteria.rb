module Loteria
	DECK_OF_CARDS = [:el_gallo, :el_diablito, :la_dama, :el_catrin, :el_paraguas, :la_sirena, :la_escalera, :la_botella,
		:el_barril, :el_arbol, :el_melon, :el_valiente, :el_gorrito, :la_muerte, :la_pera, :la_bandera, :el_bandolon,
		:el_violoncello, :la_garza, :el_pajaro, :la_mano, :la_bota, :la_luna, :el_cotorro, :el_borracho, :el_negrito,
		:el_corazon, :la_sandia, :el_tambor, :el_camaron, :las_jaras, :el_musico, :la_arana, :el_soldado, :la_estrella,
		:el_cazo, :el_mundo, :el_apache, :el_nopal, :el_alacran, :la_rosa, :la_calavera, :la_campana, :el_cantarito,
		:el_venado, :el_sol, :la_corona, :la_chalupa, :el_pino, :el_pescado, :la_palma, :la_maceta, :el_arpa, :la_rana]

	class Announcer
		def initialize
			@deck = DECK_OF_CARDS.dup.shuffle
		end

		def announce_card
			@deck.shift
		end
	end

	class Player
		attr_reader :name

		def initialize(name)
			@name = name
			@board = generate_board
		end

		def mark_card_in_board card
			deleted = @board.delete(card)

			puts "#{@name} marked #{deleted}" if deleted
		end

		def board_complete?
			@board.empty?
		end

		private

		def generate_board(size = 16)
			#board = []

			available_cards = DECK_OF_CARDS.dup.shuffle

			size.times {(board ||= []) << available_cards.shift}

			board
		end
	end

	class Game
		def initialize(*player_names)
			@announcer = Announcer.new
			@players = player_names.map { |name| Player.new name }
		end

		def play
			loop do
				card_played = @announcer.announce_card
				puts "\nCard played: #{card_played}"

				@players.each do |player|
					player.mark_card_in_board card_played

					if player.board_complete?
						puts "\nLoteria! #{player.name} won."
						raise StopIteration
					end
				end
			end
		end
	end

end

game = Loteria::Game.new "Bruce", "Alfred", "Tim", "Azrael"
p game
game.play
