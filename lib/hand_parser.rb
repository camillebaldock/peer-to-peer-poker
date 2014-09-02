require 'hand'
require 'card'

class HandParser
  #TODO: fail nicely when not 5 cards
  def parse(array_of_string_cards)
    cards = array_of_string_cards.map do |card_string|
      make_card(card_string)
    end
    Hand.new(cards)
  end

  private

  SUITS = { "h" => :heart, "d" => :diamonds, 
            "s" => :spades, "c" => :clubs}
  PIPS_FOR_HEADS = { "j" => 11, "q" => 12, "k" => 13, "a" => 14}

  #TODO: fail loudly and with better errors with unexpected inputs
  #assumes correct capitalisation, correct letters...
  def make_card(card_string)
    end_of_card_number_index = (card_string.length)-2
    pips_string = card_string[0..end_of_card_number_index]
    number_of_pips = PIPS_FOR_HEADS.fetch(pips_string, pips_string.to_i)
    Card.new(number_of_pips, SUITS.fetch(card_string[end_of_card_number_index+1]))
  end

end