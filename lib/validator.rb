require 'awesome_print'

class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    ap @puzzle_string
  end

end

# If we were gonna be fancy we'd use optparse to grab the arguments and generate a
# --help, but that seems like a good approach for v1.1. For now running with the first arg
# should be sufficient
validator = Validator.validate(ARGV[0])
