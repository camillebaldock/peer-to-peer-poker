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
    rank_type = POKER_RANKS.index(rank.fetch(:type))
    other_hand_rank_type = POKER_RANKS.index(other_hand.rank.fetch(:type))
    if rank_type == other_hand_rank_type
      if rank.fetch(:type) == :full_house
        compare_highest(rank, other_hand.rank) ||
        compare_filler(rank, other_hand.rank) ||
        0
      elsif rank.fetch(:type) == :two_pair
        compare_pairs(rank, other_hand.rank) ||
        compare_cards(rank, other_hand.rank) ||
        0
      else
        compare_value(rank, other_hand.rank) || 
        compare_cards(rank, other_hand.rank) ||
        0
      end
    else
      POKER_RANKS.index(rank.fetch(:type)) <=> POKER_RANKS.index(other_hand.rank.fetch(:type))
    end
  end

  #TODO: a lot of duplication here!!!
  def compare_cards(rank, other_rank)
    cards = rank.fetch(:cards)
    other_cards = other_rank.fetch(:cards)
    if cards != other_cards
      (cards - other_cards).max <=> (other_cards - cards).max
    end
  end

  def compare_pairs(rank, other_rank)
    cards = rank.fetch(:pairs)
    other_cards = other_rank.fetch(:pairs)
    if cards != other_cards
      (cards - other_cards).max <=> (other_cards - cards).max
    end
  end

  def compare_value(rank, other_rank)
    if rank.has_key?(:value) && rank.fetch(:value) != other_rank.fetch(:value)
      rank.fetch(:value) <=> other_rank.fetch(:value)
    end
  end

  def compare_filler(rank, other_rank)
    if rank.has_key?(:full_of)
      rank.fetch(:full_of) <=> other_rank.fetch(:full_of)
    end
  end

  def compare_highest(rank, other_rank)
    if rank.has_key?(:highest) && rank.fetch(:highest) != other_rank.fetch(:highest)
      rank.fetch(:highest) <=> other_rank.fetch(:highest)
    end
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

  def rank
    straight_flush ||
    has_four ||
    full_house ||
    flush ||
    straight ||
    has_three ||
    has_two_pairs ||
    has_two ||
    highest
  end

  private

  def pips_per_occurence
    results_per_occurence_number(cards.map(&:pips))
  end

  def suits_per_occurence
    results_per_occurence_number(cards.map(&:suit))
  end

  def highest
    { 
      :type => :highest,
      :cards => pips_per_occurence[1].sort.reverse
    }
  end

  def has_four
    if pips_per_occurence[4]
      { 
        :type => :four_of_a_kind, 
        :value => pips_per_occurence[4].first, 
        :cards => pips_per_occurence[1] 
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
        :pairs => pips_per_occurence[2].sort.reverse, 
        :cards => pips_per_occurence[1] 
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
    if pips_per_occurence[3] && pips_per_occurence[2]
      {
        :type => :full_house, 
        :highest => pips_per_occurence[3].first, 
        :full_of => pips_per_occurence[2].first
      }
    end
  end

  def flush
    if suits_per_occurence[5]
      {
        :type => :flush,
        :cards => pips_per_occurence[1].sort.reverse
      }
    end
  end

  def straight
    card_values = cards.map(&:pips)
    aces_as_ones = aces_as_ones(card_values)
    if aces_as_ones != card_values && consecutive_cards?(aces_as_ones)
      { :type => :straight, :value => 5 }
    elsif consecutive_cards?(card_values)
      { :type => :straight, :value => high_card }
    end
  end

  def straight_flush
    if flush && straight
      straight.merge(:type => :straight_flush)
    end
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