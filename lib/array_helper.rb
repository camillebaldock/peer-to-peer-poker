module ArrayHelper
  def value_occurence_count(array)
    grouped_values = array.group_by { |i| i }
    result = {}
    grouped_values.each do |key, value|
      result[key] = value.count
    end
    result
  end
end