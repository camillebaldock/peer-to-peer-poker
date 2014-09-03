require "spec_helper"
require "array_helper"

describe ArrayHelper do

  class ExampleClass
  end

  before(:each) do
    @example_class = ExampleClass.new
    @example_class.extend(ArrayHelper)
  end

  let(:sample_array) { [:a, 1, "b", "B", 1] }

  it "gives the number of occurences of each value in the array" do
    result = @example_class.value_occurence_count(sample_array)

    expect(result).to eq({ :a => 1, 1 => 2, "b" => 1, "B" => 1 })
  end
end
