require 'spec_helper'
require 'hand'
require 'hand_parser'

describe Hand do

  #TODO: this is not a nice interface
  let(:pair_hand) {
    HandParser.new.parse(["5h", "5d", "6d", "7d", "8d"])
  }
  let(:highest_hand) {
    HandParser.new.parse(["4h", "5d", "6d", "7d", "9d"])
  }
  let(:three_of_a_kind_hand) {
    HandParser.new.parse(["5h", "5d", "5s", "7d", "8d"])
  }
  let(:four_of_a_kind_hand) {
    HandParser.new.parse(["5h", "5d", "5s", "5c", "8d"])
  }
  let(:full_house_hand) {
    HandParser.new.parse(["5h", "5d", "5s", "6c", "6h"])
  }
  let(:flush_hand) {
    HandParser.new.parse(["5h", "6h", "7h", "8h", "10h"])
  }
  let(:straight_hand) {
    HandParser.new.parse(["5h", "6h", "7h", "8h", "9d"])
  }
  let(:straight_hand_low_ace) {
    HandParser.new.parse(["2h", "3h", "4h", "5h", "ad"])
  }
  let(:straight_hand_high_ace) {
    HandParser.new.parse(["10h", "jh", "qh", "kh", "ad"])
  }

  describe "#better_than" do
    it "tells me if the hand is better" do
      expect(four_of_a_kind_hand.better_than?(full_house_hand)).to be true
    end
  end

  describe "#pip_count" do
    it "returns information about the winning potential of the hand" do
      expect(pair_hand.pip_count).to eq ({ 5 => 2, 6 => 1, 7 => 1, 8 => 1 })
    end
  end

  describe "#suit_count" do
    it "returns information about the winning potential of the hand" do
      expect(pair_hand.suit_count).to eq ({ :heart => 1, :diamonds => 4 })
    end
  end

  describe "#rank" do
    it "returns information about the winning potential of the hand" do
      expect(pair_hand.rank).to eq ({:type => :pair})
    end

    it "returns information about the winning potential of the hand" do
      expect(highest_hand.rank).to eq ({:type => :highest})
    end

    it "returns information about the winning potential of the hand" do
      expect(three_of_a_kind_hand.rank).to eq ({:type => :three_of_a_kind})
    end

    it "returns information about the winning potential of the hand" do
      expect(four_of_a_kind_hand.rank).to eq ({:type => :four_of_a_kind})
    end

    it "returns information about the winning potential of the hand" do
      expect(full_house_hand.rank).to eq ({:type => :full_house})
    end

    it "returns information about the winning potential of the hand" do
      expect(flush_hand.rank).to eq ({:type => :flush})
    end

    it "returns information about the winning potential of the hand" do
      expect(straight_hand.rank).to eq ({:type => :straight})
    end

    it "works with a straight with low ace" do
      expect(straight_hand_low_ace.rank).to eq ({:type => :straight})
    end

    it "works with a straight with high ace" do
      expect(straight_hand_high_ace.rank).to eq ({:type => :straight})
    end
  end
end