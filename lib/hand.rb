class Hand

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def better_than?(other_hand)
    POKER_RANKS.index(rank.fetch(:type)) > POKER_RANKS.index(other_hand.rank.fetch(:type))
  end

  POKER_RANKS = [
    :full_house,
    :four_of_a_kind,
  ]

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
      { :type => :straight }
    elsif has_three
      { :type => :three_of_a_kind }
    elsif has_two_pairs
      { :type => :two_pair }
    elsif has_two
      { :type => :pair }
    else
      { :type => :highest }
    end
  end

  ##bob
  def pip_count
    grouped_cards = cards.map(&:pips).group_by { |i| i }
    grouped_cards.each do |key, value|
      grouped_cards[key] = value.count
    end
  end

  ##DUPE! pip_count
  def suit_count
    grouped_cards = cards.map(&:suit).group_by { |i| i }
    grouped_cards.each do |key, value|
      grouped_cards[key] = value.count
    end
  end

  private

  def has_four
    pip_count.values.include?(4)
  end

  def has_three
    pip_count.values.include?(3)
  end

  def has_two_pairs
    grouped_pip_counts = pip_count.values.group_by { |i| i }
    grouped_pip_counts[2] && grouped_pip_counts[2].size == 2
  end

  def has_two
    pip_count.values.include?(2)
  end

  def full_house
    has_three && has_two
  end

  def flush
    suit_count.values.include?(5)
  end

  def straight
    card_values = cards.map(&:pips)
    number_aces = card_values.select{|i| i == 14}.count
    if number_aces >= 1
      aces_as_ones = card_values.clone
      aces_as_ones.delete(14)
      number_aces.times do
        aces_as_ones << 1
      end
      consecutive_cards?(card_values) || 
      consecutive_cards?(aces_as_ones)
    else
      consecutive_cards?(card_values)
    end
  end

  def straight_flush
    straight && flush
  end

  #TODO: live in a helper, utility
  def consecutive_cards?(card_values)
    card_values.sort!
    #Magic number 4 => always 5 cards per hand
    difference_always_1 = true
    i = 0
    while (difference_always_1 && i < 4) do
      difference_between_pips = card_values[i+1] - card_values[i]
      difference_always_1 = difference_between_pips == 1
      i += 1
    end
    difference_always_1
  end

end