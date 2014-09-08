class CardAsTwoIntegersParser

  def parse(array_suit_pips)
    {
      :pips => pips_lookup(array_suit_pips[1]), 
      :suit => suit_lookup(array_suit_pips[0])
    }
  end

  private

  SUITS = { 
    "1" => :hearts, 
    "3" => :diamonds, 
    "2" => :spades, 
    "4" => :clubs
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
    "11" => 11, 
    "12" => 12, 
    "13" => 13,
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