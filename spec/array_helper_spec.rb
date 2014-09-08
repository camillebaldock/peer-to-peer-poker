require "spec_helper"
require "array_helper"

describe ArrayHelper do

  class ExampleClass
  end

  before(:each) do
    @example_class = ExampleClass.new
    @example_class.extend(ArrayHelper)
  end

  let(:sample_array) { [:a, 1, "b", "B", 1, 3, 3] }

  describe "#results_per_occurence_number" do
    it "gives the number of occurences of each value in the array" do
      result = @example_class.results_per_occurence_number(sample_array)

      expect(result).to eq({ 2 => [1, 3], 1 => [:a, "b", "B"] })
    end
  end

  describe "#array_consecutive_integers?" do
    let(:consecutive_array) { [2,3,4,5,6,7] }
    let(:consecutive_duplicate_array) { [2,3,4,4] }
    let(:consecutive_unordered_array) { [2,5,3,4,1] }
    let(:non_consecutive_array) { [1,4,5,6,7] }

    it "returns true if the array is made of consecutive integers" do
      result = @example_class.array_consecutive_integers?(consecutive_array)

      expect(result).to be true
    end

    it "returns false if the array is made of consecutive integers with a duplicate" do
      result = @example_class.array_consecutive_integers?(consecutive_duplicate_array)

      expect(result).to be false
    end

    it "returns true if the array is made of unordered consecutive integers" do
      result = @example_class.array_consecutive_integers?(consecutive_unordered_array)

      expect(result).to be true
    end

    it "returns false if the array is not made of consecutive integers" do
      result = @example_class.array_consecutive_integers?(non_consecutive_array)

      expect(result).to be false
    end

    it "returns true if the the array is empty" do
      result = @example_class.array_consecutive_integers?([])

      expect(result).to be true
    end

    it "returns true if the array has only one element" do
      result = @example_class.array_consecutive_integers?([1])

      expect(result).to be true
    end
  end
end
