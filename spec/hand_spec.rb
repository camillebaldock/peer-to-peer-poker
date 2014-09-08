require 'spec_helper'
require 'hand'
require 'hand_array_parser'
require 'card_parser'
require 'card'

describe Hand do

  let(:card_parser) { CardParser.new }
  let(:hand_parser) { HandArrayParser.new(card_parser) }
  let(:pair_hand_string_array) { ["5h", "5d", "6d", "7d", "8d"] }
  let(:hand_string_array) { pair_hand_string_array }
  let(:other_hand_string_array) { pair_hand_string_array }
  let(:hand) { described_class.new(hand_string_array, hand_parser) }
  let(:other_hand) { described_class.new(other_hand_string_array, hand_parser) }

  describe "hand comparisons" do
    it "tells me if the hand is better" do
      four_of_a_kind_hand = described_class.new(["5h", "5d", "5s", "5c", "8d"] , hand_parser)
      full_house_hand = described_class.new(["5h", "5d", "5s", "6c", "6h"], hand_parser)

      expect(four_of_a_kind_hand).to be > full_house_hand
    end
  end

  describe "#rank" do
    context "pair hand" do
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :pair
      end
      it "returns the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [8,7,6]
      end
      context "comparison" do
        context "with a hand with a lower pair" do
          let(:other_hand_string_array) { ["4h", "4d", "6s", "7s", "8s"]  }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same pair but lower cards" do
          let(:other_hand_string_array) { ["5s", "5c", "2d", "7s", "8s"]  }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same pair and same pips for other cards" do
          let(:other_hand_string_array) { ["5s", "5c", "6s", "7s", "8s"]  }
          it "is a tie" do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context "high card" do
      let(:hand_string_array) { ["4h", "5d", "6d", "7d", "9d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :highest
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [9,7,6,5,4]
      end
      context "comparison" do
        context "with a hand with lower cards" do
          let(:other_hand_string_array) { ["4s", "5c", "2d", "3s", "9s"]  }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
      end
    end

    context "three of a kind" do
      let(:hand_string_array) { ["5h", "5d", "5s", "7d", "8d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :three_of_a_kind
      end
      it "returns the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [8,7]
      end
      context "comparison" do
        context "with a hand with the same three of a kind but lower cards" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "7s", "6s"] }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same three of a kind and same pips for other cards" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "7s", "8s"]  }
          it "is a tie" do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context "four of a kind" do
      let(:hand_string_array) { ["5h", "5d", "5s", "5c", "8d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :four_of_a_kind
      end
      it "sets the value correctly" do
        expect(hand.rank.fetch(:value)).to eq 5
      end
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:cards).first).to eq 8
      end
      context "comparison" do
        context "with a hand with the same four of a kind but lower cards" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "5c", "6s"] }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same four of a kind and same pips for other cards" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "5c", "8h"]  }
          it "is a tie" do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context "full house" do
      let(:hand_string_array) { ["5h", "5d", "5s", "6c", "6h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :full_house
      end
      it "returns the highest correctly" do
        expect(hand.rank.fetch(:highest)).to eq 5
      end
      it "returns the full_of value correctly" do
        expect(hand.rank.fetch(:full_of)).to eq 6
      end
      context "comparison" do
        context "with a hand with a smaller highest" do
          let(:other_hand_string_array) { ["4h", "4d", "4s", "6c", "6h"]  }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same highest but lower filler" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "4c", "4h"]  }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same highest and same filler" do
          let(:other_hand_string_array) { ["5h", "5d", "5s", "6s", "6d"]  }
          it "is a tie" do
            expect(hand).to be == other_hand
          end
        end
      end
    end
    
    context "flush hand" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "10h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :flush
      end
      it "returns the other cards correctly" do
        expect(hand.rank.fetch(:cards)).to eq [10,8,7,6,5]
      end
    end

    context "straight hand" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "9d"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 9
      end
    end

    context "straight with low ace hand" do
      let(:hand_string_array) { ["2h", "3h", "4h", "5h", "ad"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 5
      end
    end

    context "straight with high ace hand" do
      let(:hand_string_array) { ["10h", "jh", "qh", "kh", "ad"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 14
      end
    end

    context "two pairs" do
      let(:hand_string_array) { ["4h", "4d", "7d", "7h", "9s"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :two_pair
      end
      it "sets the pairs correctly" do
        expect(hand.rank.fetch(:pairs)).to eq [7,4]
      end
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:cards).first).to eq 9
      end
      context "comparison" do
        context "with a hand with no identical pairs, best pair lower, same kicker" do
          let(:other_hand_string_array) { ["5h", "5d", "6d", "6h", "9s"] }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with lower high pair, sane lower pair, same kicker" do
          let(:other_hand_string_array) { ["4h", "4d", "6d", "6h", "9s"] }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with high identical pair, one lower pair, same kicker" do
          let(:other_hand_string_array) { ["3h", "3d", "7d", "7h", "9s"] }
          it "is better" do
            expect(hand).to be > other_hand
          end
        end
        context "with a hand with the same two pairs and same pips on kicker" do
          let(:other_hand_string_array) { ["4h", "4d", "7d", "7s", "9d"] }
          it "is a tie" do
            expect(hand).to be == other_hand
          end
        end
      end
    end

    context "two pairs with low kicker" do
      let(:hand_string_array) { ["4h", "4d", "6d", "6h", "2s"] }
      it "sets the kicker correctly" do
        expect(hand.rank.fetch(:cards).first).to eq 2
      end
    end

    context "straight flush" do
      let(:hand_string_array) { ["5h", "6h", "7h", "8h", "9h"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 9
      end
    end

    context "straight flush with low ace hand" do
      let(:hand_string_array) { ["2h", "3h", "4h", "5h", "ah"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 5
      end
    end

    context "straight flush with high ace hand" do
      let(:hand_string_array) { ["10h", "jh", "qh", "kh", "ah"] }
      it "ranks the hand correctly" do
        expect(hand.rank.fetch(:type)).to eq :straight_flush
      end
      it "sets the highest hand correctly" do
        expect(hand.rank.fetch(:highest)).to eq 14
      end
    end
  end
end