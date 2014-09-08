#Download 'poker-hand-testing.data' dataset from http://archive.ics.uci.edu/ml/datasets/Poker+Hand.
#Execute this script with path to the data file as the first argument.
#
#bundle exec ruby test_rankings_large_data_set.rb ~/Downloads/poker-hand-testing.data

require_relative 'lib/card_as_two_integers_parser'
require_relative 'lib/errors'
require_relative 'lib/hand_string_parser'
require_relative 'lib/array_helper'
require_relative 'lib/hand'
require_relative 'lib/card'

RANKS =
{
  0 => :highest,
  1 => :pair,
  2 => :two_pair,
  3 => :three_of_a_kind,
  4 => :straight,
  5 => :flush,
  6 => :full_house,
  7 => :four_of_a_kind,
  8 => :straight_flush,
  9 => :royal_flush,
}

data_file = ARGV[0]

File.new(data_file).each do |line|
  cards = line.chop.chop
  expected_rank_integer = line.split(",").last.to_i
  expected_rank = RANKS.fetch(expected_rank_integer)

  card_parser = CardAsTwoIntegersParser.new
  hand_parser = HandStringParser.new(card_parser)
  hand = Hand.new(cards, hand_parser)
  rank = hand.rank.fetch(:type)

  if rank != expected_rank
    puts "Inconsistency found in: #{line}, expected #{expected_rank} got #{rank}"
  end
end