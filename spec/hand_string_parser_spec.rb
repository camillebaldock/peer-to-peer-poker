require "spec_helper"
require "hand_string_parser"

describe HandStringParser do

  let(:card_parser) { double(:card_parser, :parse => nil) }
  let(:five_cards) { "1,1,1,13,2,4,2,3,1,12" }
  let(:five_cards_separated) { [["1","1"], ["1","13"], ["2","4"], ["2","3"], ["1","12"]] }
  let(:four_cards) { "1,1,1,13,2,4,2,3" }

  describe "#initialize" do
    it "succeeds with an array of five elements" do
      expect{described_class.new(card_parser).parse(five_cards)}.not_to raise_error
    end

    it "fails with an array that does not have the right number of elements" do
      expect{described_class.new(card_parser).parse(four_cards)}.to raise_error(WrongNumberOfCardsError)
    end
  end

  describe "#parse" do
    it "returns an array of 5 elements" do
      parsed_cards = described_class.new(card_parser).parse(five_cards)
      expect(parsed_cards.count).to eq 5
    end

    it "parses all the card strings" do
      parsed_cards = described_class.new(card_parser).parse(five_cards)
      five_cards_separated.each do |card_suit_pips_array|
        expect(card_parser).to have_received(:parse).with(card_suit_pips_array)
      end
    end
  end

end