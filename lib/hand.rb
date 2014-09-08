class Hand
  include ArrayHelper
  include Comparable

  attr_reader :cards

  def initialize(card_input, hand_parser)
    card_hashes = hand_parser.parse(card_input)
    @cards = card_hashes.map do |card_hash|
      Card.new(card_hash.fetch(:pips), card_hash.fetch(:suit))
    end
  end

  #TODO: this only implements comparison for cards of different types
  #future things to handle include differentiating hands with the same type
  def <=>(other_hand)
    POKER_RANKS.index(rank.fetch(:type)) <=> POKER_RANKS.index(other_hand.rank.fetch(:type))
  end

  POKER_RANKS = [
    :highest,
    :pair,
    :two_pair,
    :three_of_a_kind,
    :straight,
    :flush,
    :full_house,
    :four_of_a_kind,
    :straight_flush,
  ]

  #TODO: refactor this once all test methods returns hashes
  def rank
    if straight_flush
      { :type => :straight_flush }
    elsif has_four
      has_four
    elsif full_house
      { :type => :full_house }
    elsif flush
      { :type => :flush }
    elsif straight
      straight
    elsif has_three
      has_three
    elsif has_two_pairs
      has_two_pairs
    elsif has_two
      has_two
    else
      #TODO: possible duplication happening on pips_per_occurence[1].sort.reverse
      { 
        :type => :highest,
        :cards => pips_per_occurence[1].sort.reverse
      }
    end
  end

  private

  def pips_per_occurence
    results_per_occurence_number(cards.map(&:pips))
  end

  def suits_per_occurence
    results_per_occurence_number(cards.map(&:suit))
  end

  def has_four
    if pips_per_occurence[4]
      { 
        :type => :four_of_a_kind, 
        :value => pips_per_occurence[4].first, 
        :kicker => pips_per_occurence[1].first 
      }
    end
  end

  def has_three
    if pips_per_occurence[3]
      { 
        :type => :three_of_a_kind,
        :value => pips_per_occurence[3].first,
        :cards => pips_per_occurence[1].sort.reverse,
      }
    end
  end

  def has_two_pairs
    if pips_per_occurence[2] && pips_per_occurence[2].size == 2
      { 
        :type => :two_pair, 
        :pairs => pips_per_occurence[2], 
        :kicker => pips_per_occurence[1].first 
      }
    end
  end

  def has_two
    if pips_per_occurence[2]
      {
        :type => :pair, 
        :value => pips_per_occurence[2].first, 
        :cards => pips_per_occurence[1].sort.reverse
      }
    end
  end

  def full_house
    pips_per_occurence[3] && pips_per_occurence[2]
  end

  def flush
    suits_per_occurence[5]
  end

  def straight
    card_values = cards.map(&:pips)
    aces_as_ones = aces_as_ones(card_values)
    if aces_as_ones != card_values && consecutive_cards?(aces_as_ones)
      { :type => :straight, :highest => 5 }
    elsif consecutive_cards?(card_values)
      { :type => :straight, :highest => high_card }
    end
  end

  def straight_flush
    straight && flush
  end

  def consecutive_cards?(card_values)
    array_consecutive_integers?(card_values)
  end

  def aces_as_ones(card_values)
    number_aces = card_values.select{|i| i == 14}.count
    result = card_values.clone
    if number_aces >= 1
      result.delete(14)
      number_aces.times do
        result << 1
      end
    end
    result
  end

  def high_card
    cards.map(&:pips).max
  end

end