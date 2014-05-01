require_relative 'pascal'

describe PascalTriangle do
    before :each do
        @triangle = PascalTriangle.new
    end

    it "Left border is always 1" do
        expect(@triangle.pascal(0, 0)).to be(1)
        expect(@triangle.pascal(0, 1)).to be(1)
        expect(@triangle.pascal(0, 2)).to be(1)
        expect(@triangle.pascal(0, 3)).to be(1)
        expect(@triangle.pascal(0, 4)).to be(1)
        expect(@triangle.pascal(0, 5)).to be(1)
        expect(@triangle.pascal(0, 6)).to be(1)
        expect(@triangle.pascal(0, 7)).to be(1)
        expect(@triangle.pascal(0, 8)).to be(1)
        expect(@triangle.pascal(0, 9)).to be(1)
    end

    it "Right border is always 1" do
        expect(@triangle.pascal(1, 1)).to be(1)
        expect(@triangle.pascal(2, 2)).to be(1)
        expect(@triangle.pascal(3, 3)).to be(1)
        expect(@triangle.pascal(4, 4)).to be(1)
        expect(@triangle.pascal(5, 5)).to be(1)
        expect(@triangle.pascal(6, 6)).to be(1)
        expect(@triangle.pascal(7, 7)).to be(1)
        expect(@triangle.pascal(8, 8)).to be(1)
        expect(@triangle.pascal(9, 9)).to be(1)
    end

    it "Level 3" do
        expect(@triangle.pascal(0, 3)).to be(1)
        expect(@triangle.pascal(1, 3)).to be(3)
        expect(@triangle.pascal(2, 3)).to be(3)
        expect(@triangle.pascal(3, 3)).to be(1)
    end

    it "Level 4" do
        expect(@triangle.pascal(0, 4)).to be(1)
        expect(@triangle.pascal(1, 4)).to be(4)
        expect(@triangle.pascal(2, 4)).to be(6)
        expect(@triangle.pascal(3, 4)).to be(4)
        expect(@triangle.pascal(4, 4)).to be(1)
    end

    it "Level 5" do
        expect(@triangle.pascal(0, 5)).to be(1)
        expect(@triangle.pascal(1, 5)).to be(5)
        expect(@triangle.pascal(2, 5)).to be(10)
        expect(@triangle.pascal(3, 5)).to be(10)
        expect(@triangle.pascal(4, 5)).to be(5)
        expect(@triangle.pascal(5, 5)).to be(1)
    end

    it "Level 6" do
        expect(@triangle.pascal(0, 6)).to be(1)
        expect(@triangle.pascal(1, 6)).to be(6)
        expect(@triangle.pascal(2, 6)).to be(15)
        expect(@triangle.pascal(3, 6)).to be(20)
        expect(@triangle.pascal(4, 6)).to be(15)
        expect(@triangle.pascal(5, 6)).to be(6)
        expect(@triangle.pascal(6, 6)).to be(1)
    end
end
