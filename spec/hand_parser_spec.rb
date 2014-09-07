require "spec_helper"
require "hand_parser"
require "wrong_number_of_cards_error"

describe HandParser do

  let(:array_of_five_cards) { ["5h", "10d", "ks", "qc", "1h"] }
  let(:array_of_four_cards) { ["5h", "10d", "ks", "qc"] }

  describe "#initialize" do
    it "succeeds with an array of five elements" do
      expect{described_class.new.parse(array_of_five_cards)}.not_to raise_error
    end

    it "fails with an array that does not have five elements" do
      expect{described_class.new.parse(array_of_four_cards)}.to raise_error(WrongNumberOfCardsError)
    end
  end

  describe "#parse" do
    it "returns a hand of 5 cards" do
      parsed_cards = described_class.new.parse(array_of_five_cards)
      expect(parsed_cards.count).to eq 5
    end

    it "returns the right cards" do
      parsed_cards = described_class.new.parse(array_of_five_cards)
      expect(parsed_cards.first.suit).to eq :hearts
      expect(parsed_cards.first.pips).to eq 5
    end

    it "returns the right cards" do
      parsed_cards = described_class.new.parse(array_of_five_cards)
      expect(parsed_cards[1].suit).to eq :diamonds
      expect(parsed_cards[1].pips).to eq 10
    end

    it "returns the right cards" do
      parsed_cards = described_class.new.parse(array_of_five_cards)
      expect(parsed_cards[2].suit).to eq :spades
      expect(parsed_cards[2].pips).to eq 13
    end
  end

end