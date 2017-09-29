require 'awesome_print'

class Validator
  #
  def self.validate(file_name)
    @file_name = file_name
    new(file_name).validate
  end

  def initialize(file_name)
    @puzzle_file = File.new(file_name, "r")
    @validity_status = ""
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

      # this builds the testable columns by iterating over each row, taking the nth digit and adding it the nth index
      # of the containing array
      num_row.each_with_index do |number, index|
        test_columns[index] ||= []
        test_columns[index] << number.to_i


        # using the row_counter plus the index, we have a coordinate for each number, so use that to build up the
        # sub_groups into testable arrays
      end
    end

    # increment the counter
    row_counter += 1

    test_validity(test_rows)
    test_validity(test_columns)
  end

  def test_validity test_arr
    test_arr.each do |row|
      # See if any of those numbers is > 0 by adding them all and seeing if it's > 0. Also test for
      # lenght, because .sum() returns 0 on an empty array, so [0] and [] will look the same
      if row.index(0) != nil
        @validity_status = "incomplete"
      elsif contains_dupe_values?(row)
        @validity_status = "invalid"
      else
        @validity_status = "valid"
      end
    end
  end

  # returns a boolean indicating whether or not the arry has duplicate values
  def contains_dupe_values? arr
    return arr.length > arr.uniq.length
  end

  def validate
    return_string = ""
    build_and_test_validatable_objects

    if @validity_status == "incomplete"
      return_string = "This sudoku is valid, but incomplete."
    elsif @validity_status == "invalid"
      return_string = "Expected #{@file_name} to be invalid but it wasn't."
    else
      return_string = "This sudoku is valid."
    end

    ap return_string
    return_string
  end

end

# If we were gonna be fancy we'd use optparse to grab the arguments and generate a
# --help, but that seems like a good approach for v1.1. For now running with the first arg
# should be sufficient
validator = Validator.validate(ARGV[0])
