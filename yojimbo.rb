# Yojimbo's function simulation
# Program to calculate number of turns and invested Gil to make FFX Aeon Yojimbo to be at maximum compatibility.
# This code covers the case when you answer option 3="To defeat the most powerful of enemies." when questioned by Yojimbo.
# Works for PS2 version (USA&Japan) and the new PS3 Final Fantasy X/X-2 HD Remaster (International)
# Once at max compatibility calculates how many "Zanmato" attacks are performed in 100 turns.
# With data from http://www.neoseeker.com/resourcelink.html?rlid=65600
class Yojimbo
	COMPATIBILITY_ATTACK = {4 => :zanmato, 3 => :wakizashi_all, 1=> :wakizashi, 0=> :kozuka, -1=> :daigoro}
	MAX_COMPATIBILITY = 255
	MIN_COMPATIBILITY = 0

	def initialize(deafault_compatibility, compatibility_divisor, version)
		@default_compatibility = deafault_compatibility
		@compatibility_divisor = compatibility_divisor
		@motivation = version
	end

	def self.international
		Yojimbo.new 128, 4, :motivation_international
	end

	def self.usa_jap
		Yojimbo.new 50, 30, :motivation_usa_jap
	end

	def attack(gil, compatibility = @default_compatibility, over_drive = false, zanmato_level = 3, break_if_max = true, times = 1000)
		@attacks = {zanmato: 0, wakizashi_all: 0, wakizashi: 0, kozuka: 0, daigoro: 0}
		motivation = send @motivation, gil

		total_gil = (1..times).each.inject(0) do |total_gil|
			compatibility += yojimbo compatibility, motivation, over_drive, zanmato_level
			compatibility = MAX_COMPATIBILITY if compatibility > MAX_COMPATIBILITY
			compatibility = MIN_COMPATIBILITY if compatibility < MIN_COMPATIBILITY
			break total_gil if break_if_max and (compatibility >= MAX_COMPATIBILITY or compatibility <= MIN_COMPATIBILITY)
			total_gil += gil
		end
		puts "Gil:#{gil}, Total Gil:#{total_gil}, Initial motivation: #{motivation}, Final compatibility #{compatibility}"
		print_stats
	end

	def attack_max_compatibility(gil, over_drive = false, zanmato_level = 3, times = 100)
		attack gil, MAX_COMPATIBILITY, over_drive, zanmato_level, false, times
	end

	private

	def print_stats
		total = @attacks.inject(0) {|sum, (a, c)| sum += c}
		puts "Total attacks [#{total}] #{@attacks}. Zanmato #{@attacks[:zanmato]*100/total} %"
	end

	def yojimbo *args
		compatibility = self.send :compatibility_function, *args

		@attacks[COMPATIBILITY_ATTACK[compatibility]] += 1

		compatibility
	end

	def compatibility_function(initial_compatibility, initial_motivation, over_drive, zanmato_level)
		motivation = initial_motivation + (initial_compatibility/@compatibility_divisor).floor
		zanmato_level_multiplier = zanmato_level <= 3 ?  0.8 : 0.4
		motivation =  (motivation*zanmato_level_multiplier).floor
		motivation += 20 if over_drive
		motivation += rand(0..63)
		if motivation >= 80
			compatibility = 4
		else
			#Recalculate in this case
			motivation = initial_motivation + (initial_compatibility/@compatibility_divisor).floor
			zanmato_level_multiplier = 0.8
			motivation =  (motivation*zanmato_level_multiplier).floor
			motivation += 20 if over_drive
			motivation += rand(0..63)
			case motivation
			when 64..10000000
				compatibility = 3
			when 48..63
				compatibility = 1
			when 32..47
				compatibility = 0
			when 0..31
				compatibility = -1
			else
				puts motivation
			end
		end

		compatibility
	end

	def motivation_international(gil)
		case gil
		when 1..3
			0
		when 4..7
			4
		when 8..15
			8
		when 16..31
			12
		when 32..63
			16
		when 64..127
			20
		when 128..255
			24
		when 256..511
			28
		when 512..1023
			32
		when 1024..2047
			36
		when 2048..4095
			40
		when 4096..8191
			44
		when 8192..16383
			48
		when 16384..32767
			52
		when 32768..65535
			56
		when 65536..131071
			60
		when 131072..262143
			64
		when 262144..524287
			68
		when 524288..1048575
			72
		when 1048576..2097151
			76
		when 2097152..4194303
			80
		when 4194304..8388607
			84
		when 8388608..16777215
			88
		when 16777216..33554431
			92
		when 33554432..67108863
			96
		when 67108864..134217727
			100
		when 134217728..268435455
			104
		when 268435456..536870911
			108
		when 536870912..999999999
			112
		end
	end

	def motivation_usa_jap(gil)
		case gil
		when 1..3
			0
		when 4..7
			2
		when 8..15
			4
		when 16..31
			6
		when 32..63
			8
		when 64..127
			10
		when 128..255
			12
		when 256..511
			14
		when 512..1023
			16
		when 1024..2047
			18
		when 2048..4095
			20
		when 4096..8191
			22
		when 8192..16383
			24
		when 16384..32767
			26
		when 32768..65535
			28
		when 65536..131071
			30
		when 131072..262143
			32
		when 262144..524287
			34
		when 524288..1048575
			36
		when 1048576..2097151
			38
		when 2097152..4194303
			40
		when 4194304..8388607
			42
		when 8388608..16777215
			44
		when 16777216..33554431
			46
		when 33554432..67108863
			48
		when 67108864..134217727
			50
		when 134217728..268435455
			52
		when 268435456..536870911
			54
		when 536870912..999999999
			56
		end
	end
end

puts "========Yojimbo international at start =========="
y = Yojimbo.international
y.attack 4
y.attack 8
y.attack 16
y.attack 32
y.attack 64
y.attack 128
y.attack 256
y.attack 512
y.attack 1024
y.attack 2048

puts "========Yojimbo international at max compatibility=========="
y = Yojimbo.international
y.attack_max_compatibility 4, false, 3
y.attack_max_compatibility 8, false, 3
y.attack_max_compatibility 16, false, 3
y.attack_max_compatibility 32, false, 3
y.attack_max_compatibility 64, false, 3
y.attack_max_compatibility 128, false, 3
y.attack_max_compatibility 256, false, 3
y.attack_max_compatibility 512, false, 3
y.attack_max_compatibility 1024, false, 3
y.attack_max_compatibility 2048, false, 3

puts "========Yojimbo international at max compatibility against strong fiends =========="
y = Yojimbo.international
y.attack_max_compatibility 4, false, 4
y.attack_max_compatibility 8, false, 4
y.attack_max_compatibility 16, false, 4
y.attack_max_compatibility 32, false, 4
y.attack_max_compatibility 64, false, 4
y.attack_max_compatibility 128, false, 4
y.attack_max_compatibility 256, false, 4
y.attack_max_compatibility 512, false, 4
y.attack_max_compatibility 1024, false, 4
y.attack_max_compatibility 2048, false, 4

puts "========Yojimbo international at max compatibility against strong fiends with Overdrive! =========="
y = Yojimbo.international
y.attack_max_compatibility 4, true, 4
y.attack_max_compatibility 8, true, 4
y.attack_max_compatibility 16, true, 4
y.attack_max_compatibility 32, true, 4
y.attack_max_compatibility 64, true, 4
y.attack_max_compatibility 128, true, 4
y.attack_max_compatibility 256, true, 4
y.attack_max_compatibility 512, true, 4
y.attack_max_compatibility 1024, true, 4
y.attack_max_compatibility 2048, true, 4


puts "========Yojimbo USA & Japan at start =========="
y = Yojimbo.usa_jap
y.attack 4
y.attack 8
y.attack 16
y.attack 32
y.attack 64
y.attack 128
y.attack 256
y.attack 512
y.attack 1024
y.attack 2048

puts "========Yojimbo USA & Japan at max compatibility=========="
y = Yojimbo.usa_jap
y.attack_max_compatibility 4, false, 3
y.attack_max_compatibility 8, false, 3
y.attack_max_compatibility 16, false, 3
y.attack_max_compatibility 32, false, 3
y.attack_max_compatibility 64, false, 3
y.attack_max_compatibility 128, false, 3
y.attack_max_compatibility 256, false, 3
y.attack_max_compatibility 512, false, 3
y.attack_max_compatibility 1024, false, 3
y.attack_max_compatibility 2048, false, 3

puts "========Yojimbo USA & Japan at max compatibility against strong fiends =========="
y = Yojimbo.usa_jap
y.attack_max_compatibility 4, false, 4
y.attack_max_compatibility 8, false, 4
y.attack_max_compatibility 16, false, 4
y.attack_max_compatibility 32, false, 4
y.attack_max_compatibility 64, false, 4
y.attack_max_compatibility 128, false, 4
y.attack_max_compatibility 256, false, 4
y.attack_max_compatibility 512, false, 4
y.attack_max_compatibility 1024, false, 4
y.attack_max_compatibility 2048, false, 4
