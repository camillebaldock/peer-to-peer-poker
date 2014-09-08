require "spec_helper"
require "card_as_two_integers_parser"

describe CardAsTwoIntegersParser do

  let(:single_digit_card_string) { ["1","5"] }
  let(:two_digit_card_string) { ["3","10"] }
  let(:jack_card_string) { ["3","11"] }
  let(:queen_card_string) { ["4","12"] }
  let(:king_card_string) { ["2","13"] }
  let(:ace_as_one_card_string) { ["3","1"] }

  it "parses a card string with a single digit number" do
    parsed_card = described_class.new.parse(single_digit_card_string)
    expect(parsed_card.fetch(:suit)).to eq :hearts
    expect(parsed_card.fetch(:pips)).to eq 5
  end

  it "parses a card string with a two digit number" do
    parsed_card = described_class.new.parse(two_digit_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:pips)).to eq 10
  end

  it "parses a jack card string" do
    parsed_card = described_class.new.parse(jack_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:pips)).to eq 11
  end

  it "parses a queen card string" do
    parsed_card = described_class.new.parse(queen_card_string)
    expect(parsed_card.fetch(:suit)).to eq :clubs
    expect(parsed_card.fetch(:pips)).to eq 12
  end

  it "parses a king card string" do
    parsed_card = described_class.new.parse(king_card_string)
    expect(parsed_card.fetch(:suit)).to eq :spades
    expect(parsed_card.fetch(:pips)).to eq 13
  end

  it "parses an ace card string" do
    parsed_card = described_class.new.parse(ace_as_one_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:pips)).to eq 14
  end

  it "fails if the card string does not have a recognised suit" do
    expect{described_class.new.parse(["s", "5"])}.to raise_error(UnrecognisedSuitError)
  end

  it "fails if the card string does not have recognised pips" do
    expect{described_class.new.parse(["1", "14"])}.to raise_error(UnrecognisedPipsError)
  end

end