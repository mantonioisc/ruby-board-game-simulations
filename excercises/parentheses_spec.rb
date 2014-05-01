require_relative 'parentheses'

describe Balancer do
    before :each do
        @balancer = Balancer.new
    end

    it "These strings should be balanced" do
        @balancer.balanced?("()").should be true
        @balancer.balanced?("()()()()()()").should be true
        @balancer.balanced?("(((((())))))").should be true
        @balancer.balanced?("(if (zero? x) max (/ 1 x))").should be true
        @balancer.balanced?("I told him (that it's not (yet) done). (But he wasn't listening)").should be true
    end

    it "These strings are unblanced" do
        @balancer.balanced?("(").should be false
        @balancer.balanced?("()()()()()(").should be false
        @balancer.balanced?("(((((()))))").should be false
        @balancer.balanced?(":-)").should be false
        @balancer.balanced?("())(").should be false
        @balancer.balanced?(")").should be false
        @balancer.balanced?(")(").should be false
        @balancer.balanced?("())(").should be false
        @balancer.balanced?("((((())))()))").should be false
        @balancer.balanced?("(()()))").should be false
    end
end
