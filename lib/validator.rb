class Validator
  def self.validate(file_name)
    @file_name = file_name
    new(file_name).validate
  end

  def initialize(file_name)
    @puzzle_file = File.new(file_name, "r")
    @validity_status = { valid: true, complete: true }
    @file_name = ""
  end

  # Reads the file row by row, building the testable objects
  def build_and_test_validatable_objects
    # each of these should turn in to a two-dimensional array, where each inner array describes the testable group
    test_rows = []
    test_columns = []
    test_sub_groups = []

    # this counter is to remember which row we're processing so we can keep track when parsing the sub groups
    # in to usable arrays
    row_counter = 0

    while(row = @puzzle_file.gets)
      # .scan() pulls out only the things matching the regex.
      # regex matches one or more digits
      num_row = row.scan(/\d+/)

      # skip the arrays that are just lines
      next if num_row == []

      # bulds the test rows. this is the most simple part
      test_rows << num_row.map(&:to_i)

      num_row.each_with_index do |number, index|
        # this builds the testable columns by iterating over each row, taking the nth digit and adding it the nth index
        # of the containing array
        test_columns[index] ||= []
        test_columns[index] << number.to_i
      end

      # this breaks the sub groups in to semi-testable arrays like above, but each internal array contains
      # 3 sub groups. Because the numbers are still in their original groups of three and in order order of columns
      # we can test validity by passing the numbers in groups of 9 to the validator method to validate subgroups
      num_row.each_slice(3).with_index do |numbers, index|
        test_sub_groups[index] ||= []

        if row_counter <= 2
          test_sub_groups[index] << numbers
        elsif row_counter > 2 && row_counter <= 5
          test_sub_groups[index] << numbers
        else
          test_sub_groups[index] << numbers
        end
      end

      # increment the counter
      row_counter += 1
    end

    # flatten the arrays and coerce to int so we can look for 0 later
    test_sub_groups.map! do |inner_arr|
      inner_arr.flatten!
      inner_arr.map(&:to_i)
    end

    test_validity(test_rows)
    test_validity(test_columns)


    # The first array represents the column of sub groups, while the inner array represents the row
    test_sub_groups.each do |sub_group_col|
      sub_group_col.each_slice(9) do |sub_group|
        # this is admittably some funniness of design--the test_validity method expects a 2 dimensional array to test,
        # here we're only generating a flat array, so we can get around that by wrapping the sub_group in another array
        # to the same effect
        test_validity([sub_group])
      end
    end
  end

  def test_validity test_arr
    test_arr.each do |row|
      # See if any of those numbers is > 0 by adding them all and seeing if it's > 0. Also test for
      # lenght, because .sum() returns 0 on an empty array, so [0] and [] will look the same

      if row.index(0) != nil
        @validity_status[:complete] = false
      end

      if contains_dupe_values?(row)
        @validity_status[:valid] = false
      end
    end
  end

  # returns a boolean indicating whether or not the arry has duplicate values
  def contains_dupe_values? arr
    arr.delete_if { |value| value == 0 }
    return arr != arr.uniq
  end

  def validate
    return_string = ""
    build_and_test_validatable_objects

    if !@validity_status[:valid]
      return_string = "This sudoku is invalid."
    elsif @validity_status[:valid] && !@validity_status[:complete]
      return_string = "This sudoku is valid, but incomplete."
    else
      return_string = "This sudoku is valid."
    end

    return_string
  end

end

# This is for debugging and dev purposes. Just comment out the last line and you can run this in the terminal
# ruby validator.rb path/to/file
# If we were gonna be fancy we'd use optparse to grab the arguments and generate a
# --help, but that seems like a good approach for v1.1. For now running with the first arg
# should be sufficient
# Validator.validate(ARGV[0])
