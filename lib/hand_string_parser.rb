require "errors"

class HandStringParser
  #Parser for hands written as documented in:
  #https://archive.ics.uci.edu/ml/machine-learning-databases/poker/poker-hand.names

  def initialize(card_parser)
    @card_parser = card_parser
  end

  def parse(hand_string)
    array_of_entries = hand_string.split(",")
    if array_of_entries.size != 10
      raise WrongNumberOfCardsError
    end
    array_of_entries.each_slice(2).map do |card_suit_pips_array|
      @card_parser.parse(card_suit_pips_array)
    end
  end

end