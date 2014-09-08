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

  def <=>(other_hand)
    rank_type = POKER_RANKS.index(rank.fetch(:type))
    other_hand_rank_type = POKER_RANKS.index(other_hand.rank.fetch(:type))
    if rank_type == other_hand_rank_type
      compare_value(:value, rank, other_hand.rank) || 
      compare_value(:full_of, rank, other_hand.rank) ||
      compare_card_arrays(:pairs, rank, other_hand.rank) ||
      compare_card_arrays(:cards, rank, other_hand.rank) ||
      0
    else
      rank_type <=> other_hand_rank_type
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
    four_of_a_kind ||
    full_house ||
    flush ||
    straight ||
    three_of_a_kind ||
    two_pair ||
    pair ||
    highest
  end

  private

  def straight_flush
    if flush && straight
      straight.merge(:type => :straight_flush)
    end
  end

  def four_of_a_kind
    if pips_per_occurence[4]
      { 
        :type => :four_of_a_kind, 
        :value => pips_per_occurence[4].first, 
        :cards => pips_per_occurence[1] 
      }
    end
  end

  def full_house
    if pips_per_occurence[3] && pips_per_occurence[2]
      {
        :type => :full_house, 
        :value => pips_per_occurence[3].first, 
        :full_of => pips_per_occurence[2].first
      }
    end
  end

  def flush
    if suits_per_occurence[5]
      {
        :type => :flush,
        :cards => pips_per_occurence[1]
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

  def three_of_a_kind
    if pips_per_occurence[3]
      { 
        :type => :three_of_a_kind,
        :value => pips_per_occurence[3].first,
        :cards => pips_per_occurence[1],
      }
    end
  end

  def two_pair
    if pips_per_occurence[2] && pips_per_occurence[2].size == 2
      { 
        :type => :two_pair, 
        :pairs => pips_per_occurence[2], 
        :cards => pips_per_occurence[1] 
      }
    end
  end

  def pair
    if pips_per_occurence[2]
      {
        :type => :pair, 
        :value => pips_per_occurence[2].first, 
        :cards => pips_per_occurence[1]
      }
    end
  end

  def highest
    { 
      :type => :highest,
      :cards => pips_per_occurence[1]
    }
  end

  def pips_per_occurence
    result = results_per_occurence_number(cards.map(&:pips))
    result.each do |nb_occurence, pips|
      result[nb_occurence] = pips.sort.reverse
    end
    result
  end

  def suits_per_occurence
    results_per_occurence_number(cards.map(&:suit))
  end

  def compare_card_arrays(key, rank, other_rank)
    if rank.has_key?(key)
      cards = rank.fetch(key)
      other_cards = other_rank.fetch(key)
      if cards != other_cards
        (cards - other_cards).max <=> (other_cards - cards).max
      end
    end
  end

  def compare_value(key, rank, other_rank)
    if rank.has_key?(key)
      if rank.fetch(key) != other_rank.fetch(key)
        rank.fetch(key) <=> other_rank.fetch(key)
      end
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