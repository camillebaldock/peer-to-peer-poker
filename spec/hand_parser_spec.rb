require "spec_helper"
require "hand_parser"

describe HandParser do
  describe "#parse"
  it "returns a hand of cards" do
    array_of_cards = ["5h", "6d", "ks", "qc", "1h"]
    hand = described_class.new.parse(array_of_cards)
    expect(hand.cards.count).to eq 5
  end

  it "returns the right cards" do
    array_of_cards = ["6d"]
    hand = described_class.new.parse(array_of_cards)
    expect(hand.cards.first.suit).to eq :diamonds
    expect(hand.cards.first.pips).to eq 6
  end

  it "returns the right cards" do
    array_of_cards = ["10d"]
    hand = described_class.new.parse(array_of_cards)
    expect(hand.cards.first.suit).to eq :diamonds
    expect(hand.cards.first.pips).to eq 10
  end

  it "returns the right cards" do
    array_of_cards = ["qd"]
    hand = described_class.new.parse(array_of_cards)
    expect(hand.cards.first.suit).to eq :diamonds
    expect(hand.cards.first.pips).to eq 12
  end

end