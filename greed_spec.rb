require_relative 'greed'

#Install rspec using: gem install rspec
#Run with: rspec greed_spec.rb
describe DiceSet do
    it "Roles one dice" do
        dice_set = DiceSet.new
        dice_set.roll 1

        dice_set.values.size.should eq(1)
        expect(dice_set.values.first).to be >= 1
        expect(dice_set.values.first).to be <= 6
    end

    it "Roles many dices" do
        dice_set = DiceSet.new
        dice_set.roll 5

        dice_set.values.size.should eq(5)
        dice_set.values.each do |x|
            expect(x).to be >= 1
            expect(x).to be <= 6
        end
    end
end

describe Player do
    before :each do
        @player = Player.new "john doe"
    end

    it "Player takes turn" do
        dice_set = double("dice_set")
        dice_set.should_receive(:roll).with(NUMBER_OF_DICE).once

        @player.take_turn dice_set
    end

    describe "#keep_rolling?" do
        it "should not keep rolling when no dices left" do
            @player.keep_rolling?(0, 0).should be false
            @player.keep_rolling?(1000, 0).should be false
        end

        it "should keep rolling if the score is bellow the minimum limit" do
            @player.keep_rolling?(MINIMUM_SCORE, NUMBER_OF_DICE).should be true
        end

        it "#keep_rolling based on rand to emulate decision: true" do
            @player.should_receive(:rand).with(any_args()).and_return(0)
            @player.keep_rolling?(MINIMUM_SCORE + 1 , NUMBER_OF_DICE).should be true
        end

        it "#keep_rolling based on rand to emulate decision: false" do
            @player.should_receive(:rand).with(any_args()).and_return(1)
            @player.keep_rolling?(MINIMUM_SCORE + 1 , NUMBER_OF_DICE).should be false
        end
    end
end

describe GreedGame do
    before :each do
        @greed = GreedGame.new "1", "2", "3"
    end

    it "Has players" do
        expect(@greed.players.size).to eq(3)
        expect(@greed.players.map{|k, v| k.name}).to eq ["1", "2", "3"]
    end

    it "Plays and returns the winner" do
        winner = @greed.play
        expect(winner).to be_true #not nil
        expect(winner).to be_a_kind_of Player
    end

    describe "#calculate_score" do
        it "Generate 0 for empty values" do
            @greed.send(:calculate_score, []).should eq([0, 0])
        end

        it "Generate 0 for 0's" do
            @greed.send(:calculate_score, [0, 0, 0]).should eq([0, 0])
        end

        it "Generate 1000 points for 3 1's" do
            @greed.send(:calculate_score, [1, 1, 1]).should eq([1000, 0])
        end

        it "Generate 100 points for each 1" do
            @greed.send(:calculate_score, [1,]).should eq([100, 0])
            @greed.send(:calculate_score, [1, 1]).should eq([200, 0])
        end

        it "Generate 50 points for each 5" do
            @greed.send(:calculate_score, [5,]).should eq([50, 0])
            @greed.send(:calculate_score, [5, 5]).should eq([100, 0])
        end

        it "Generate 100 times number points for 3 of each number" do
            @greed.send(:calculate_score, [2, 2, 2]).should eq([200, 0])
            @greed.send(:calculate_score, [3, 3, 3]).should eq([300, 0])
            @greed.send(:calculate_score, [4, 4, 4]).should eq([400, 0])
            @greed.send(:calculate_score, [5, 5, 5]).should eq([500, 0])
            @greed.send(:calculate_score, [6, 6, 6]).should eq([600, 0])
            @greed.send(:calculate_score, [7, 7, 7]).should eq([700, 0])
            @greed.send(:calculate_score, [8, 8, 8]).should eq([800, 0])
            @greed.send(:calculate_score, [9, 9, 9]).should eq([900, 0])
        end

        it "Generate 100 times number points for 3 of each number and discards the rest (but for 5)" do
            @greed.send(:calculate_score, [2, 2, 2, 2, 2]).should eq([200, 2])
            @greed.send(:calculate_score, [3, 3, 3, 3, 3]).should eq([300, 2])
            @greed.send(:calculate_score, [4, 4, 4, 4, 4]).should eq([400, 2])
            @greed.send(:calculate_score, [5, 5, 5, 5, 5]).should eq([600, 0])
            @greed.send(:calculate_score, [6, 6, 6, 6, 6]).should eq([600, 2])
            @greed.send(:calculate_score, [7, 7, 7, 7, 7]).should eq([700, 2])
            @greed.send(:calculate_score, [8, 8, 8, 8, 8]).should eq([800, 2])
            @greed.send(:calculate_score, [9, 9, 9, 9, 9]).should eq([900, 2])
        end

        it "Returns non scoring dices" do
            @greed.send(:calculate_score, [2]).should eq([0, 1])
            @greed.send(:calculate_score, [2, 2]).should eq([0, 2])
        end

        it "Counts no points for single numbers (but 1 and 5)" do
            @greed.send(:calculate_score, [2, 3, 4, 6, 7, 8, 9]).should eq([0, 7])
        end
    end
end
