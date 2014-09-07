require "errors"

class CardParser

  def parse(card_string)
    end_of_card_number_index = (card_string.length)-2
    pips_string = card_string[0..end_of_card_number_index]
    suit_string = card_string[end_of_card_number_index+1]
    {
      :pips => pips_lookup(pips_string), 
      :suit => suit_lookup(suit_string)
    }
  end

  private

  SUITS = { 
    "h" => :hearts, 
    "d" => :diamonds, 
    "s" => :spades, 
    "c" => :clubs
  }

  PIPS = {
    "1" => 14,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "j" => 11, 
    "q" => 12, 
    "k" => 13, 
    "a" => 14
  }

  def pips_lookup(pips_string)
    begin
      PIPS.fetch(pips_string)
    rescue KeyError
      raise UnrecognisedPipsError
    end
  end

  def suit_lookup(suit_string)
    begin
      SUITS.fetch(suit_string)
    rescue KeyError
      raise UnrecognisedSuitError
    end
  end
end