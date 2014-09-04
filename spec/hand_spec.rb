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
  let(:two_pair_hand) {
    HandParser.new.parse(["4h", "4d", "6d", "6h", "9s"])
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
  let(:straight_flush_hand) {
    HandParser.new.parse(["5h", "6h", "7h", "8h", "9h"])
  }

  describe "#better_than" do
    it "tells me if the hand is better" do
      expect(four_of_a_kind_hand.better_than?(full_house_hand)).to be true
    end
  end

  describe "#pips_occurrence_count" do
    it "returns the correct pips occurrence count" do
      expect(pair_hand.pips_occurence_count).to eq ({ 5 => 2, 6 => 1, 7 => 1, 8 => 1 }.values)
    end
  end

  describe "#suit_occurrence_count" do
    it "returns the correct suit occurrence count" do
      expect(pair_hand.suit_occurence_count).to eq ({ :heart => 1, :diamonds => 4 }.values)
    end
  end

  describe "#rank" do
    it "ranks a pair hand correctly" do
      expect(pair_hand.rank).to eq ({:type => :pair})
    end

    it "ranks a high card hand correctly" do
      expect(highest_hand.rank).to eq ({:type => :highest})
    end

    it "ranks a three of a kind hand correctly" do
      expect(three_of_a_kind_hand.rank).to eq ({:type => :three_of_a_kind})
    end

    it "ranks a four of a kind hand correctly" do
      expect(four_of_a_kind_hand.rank).to eq ({:type => :four_of_a_kind})
    end

    it "ranks a full house hand correctly" do
      expect(full_house_hand.rank).to eq ({:type => :full_house})
    end

    it "ranks a flush hand correctly" do
      expect(flush_hand.rank).to eq ({:type => :flush})
    end

    it "ranks a straight hand correctly" do
      expect(straight_hand.rank).to eq ({:type => :straight})
    end

    it "ranks a straight with low ace hand correctly" do
      expect(straight_hand_low_ace.rank).to eq ({:type => :straight})
    end

    it "ranks a straight with high ace hand correctly" do
      expect(straight_hand_high_ace.rank).to eq ({:type => :straight})
    end

    it "ranks a two pair hand correctly" do
      expect(two_pair_hand.rank).to eq ({:type => :two_pair})
    end

    it "ranks a straight flush hand correctly" do
      expect(straight_flush_hand.rank).to eq ({:type => :straight_flush})
    end
  end
end