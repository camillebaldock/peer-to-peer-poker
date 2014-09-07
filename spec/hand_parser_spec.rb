require "spec_helper"
require "hand_parser"
require "wrong_number_of_cards_error"

describe HandParser do

  let(:card_parser) { double(:card_parser, :parse => nil) }
  let(:array_of_five_cards) { ["5h", "10d", "ks", "qc", "1h"] }
  let(:array_of_four_cards) { ["5h", "10d", "ks", "qc"] }

  describe "#initialize" do
    it "succeeds with an array of five elements" do
      expect{described_class.new(card_parser).parse(array_of_five_cards)}.not_to raise_error
    end

    it "fails with an array that does not have five elements" do
      expect{described_class.new(card_parser).parse(array_of_four_cards)}.to raise_error(WrongNumberOfCardsError)
    end
  end

  describe "#parse" do
    it "returns an array of 5 elements" do
      parsed_cards = described_class.new(card_parser).parse(array_of_five_cards)
      expect(parsed_cards.count).to eq 5
    end

    it "parses all the card strings" do
      parsed_cards = described_class.new(card_parser).parse(array_of_five_cards)
      array_of_five_cards.each do |card_string|
        expect(card_parser).to have_received(:parse).with(card_string)
      end
    end
  end

end