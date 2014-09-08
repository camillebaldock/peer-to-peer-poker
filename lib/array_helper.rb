module ArrayHelper

  def results_per_occurence_number(array)
    grouped_values = array.group_by { |i| i }
    result = {}
    grouped_values.each do |key, value|
      if result[value.count]
       result[value.count] << key
      else
        result[value.count] = [key]
      end
    end
    result
  end

  def array_consecutive_integers?(array)
    array.sort!
    difference_always_1 = true
    i = 0
    while (difference_always_1 && i < (array.size - 1)) do
      difference_between_values = array[i+1] - array[i]
      difference_always_1 = difference_between_values == 1
      i += 1
    end
    difference_always_1
  end
end