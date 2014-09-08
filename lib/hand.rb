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
      { :type => :four_of_a_kind }
    elsif full_house
      { :type => :full_house }
    elsif flush
      { :type => :flush }
    elsif straight
      straight
    elsif has_three
      { :type => :three_of_a_kind }
    elsif has_two_pairs
      has_two_pairs
    elsif has_two
      { :type => :pair }
    else
      { :type => :highest }
    end
  end

  def pips_occurence_count
    value_occurence_count(cards.map(&:pips)).values
  end

  def suit_occurence_count
    value_occurence_count(cards.map(&:suit)).values
  end

  private

  def has_four
    pips_occurence_count.include?(4)
  end

  def has_three
    pips_occurence_count.include?(3)
  end

  def has_two_pairs
    results_per_occurence = results_per_occurence_number(cards.map(&:pips))
    if results_per_occurence[2] && results_per_occurence[2].size == 2
      { 
        :type => :two_pair, 
        :pairs => results_per_occurence[2], 
        :kicker => results_per_occurence[1].first 
      }
    end
  end

  def has_two
    pips_occurence_count.include?(2)
  end

  def full_house
    has_three && has_two
  end

  def flush
    suit_occurence_count.include?(5)
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