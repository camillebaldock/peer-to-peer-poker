class CardParser

  SUITS = { 
    "h" => :hearts, 
    "d" => :diamonds, 
    "s" => :spades, 
    "c" => :clubs
  }

  PIPS_FOR_HEADS = { 
    "j" => 11, 
    "q" => 12, 
    "k" => 13, 
    "a" => 14
  }

  def parse(card_string)
    end_of_card_number_index = (card_string.length)-2
    pips_string = card_string[0..end_of_card_number_index]
    number_of_pips = PIPS_FOR_HEADS.fetch(pips_string, pips_string.to_i)
    {
      :pips => number_of_pips, 
      :suit => SUITS.fetch(card_string[end_of_card_number_index+1])
    }
  end
end