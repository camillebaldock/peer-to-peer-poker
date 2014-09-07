require "errors"

class HandParser

  def initialize(card_parser)
    @card_parser = card_parser
  end

  def parse(array_of_string_cards)
    if array_of_string_cards.size != 5
      raise WrongNumberOfCardsError
    end
    array_of_string_cards.map do |card_string|
      @card_parser.parse(card_string)
    end
  end

end