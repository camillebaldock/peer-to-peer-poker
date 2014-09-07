require "spec_helper"
require "card_parser"

describe CardParser do

  let(:single_digit_card_string) { "5h" }
  let(:two_digit_card_string) { "10d" }
  let(:jack_card_string) { "jd" }
  let(:queen_card_string) { "qc" }
  let(:king_card_string) { "ks" }
  let(:ace_card_string) { "ad" }
  let(:ace_as_one_card_string) { "1d" }

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
    parsed_card = described_class.new.parse(ace_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:pips)).to eq 14
  end

  it "parses an ace card string when it is written as a 1" do
    parsed_card = described_class.new.parse(ace_as_one_card_string)
    expect(parsed_card.fetch(:suit)).to eq :diamonds
    expect(parsed_card.fetch(:pips)).to eq 14
  end

  it "fails if the card string does not have a recognised suit" do
    expect{described_class.new.parse("5z")}.to raise_error(UnrecognisedSuitError)
  end

  it "fails if the wrong capitalisation is used for the suit" do
    expect{described_class.new.parse("5D")}.to raise_error(UnrecognisedSuitError)
  end

  it "fails if the wrong capitalisation is used for the pips" do
    expect{described_class.new.parse("Qd")}.to raise_error(UnrecognisedPipsError)
  end

end