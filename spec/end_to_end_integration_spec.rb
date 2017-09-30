require 'spec_helper'

require_relative "../lib/validator"

describe "End-to-end test" do
  # Note: these specs are supposed to fail when you first start this exercise.
  # Your job is to make them pass.

  context "when the sudoku is valid" do
    context "and it is complete" do
      it "returns a string saying so" do
        file_path = "spec/fixtures/valid_complete.sudoku"

        result = Validator.validate(file_path)

        expect(result).to eq "This sudoku is valid."
      end
    end

    context "and it is incomplete" do
      it "returns a string saying so" do
        file_path = "spec/fixtures/valid_incomplete.sudoku"

        result = Validator.validate(file_path)

        expect(result).to eq "This sudoku is valid, but incomplete."
      end
    end
  end

  context "when the sudoku is invalid" do
    invalid_fixtures = ["spec/fixtures/invalid_due_to_row_dupe.sudoku",
                        "spec/fixtures/invalid_due_to_column_dupe.sudoku",
                        "spec/fixtures/invalid_due_to_subgroup_dupe.sudoku"]

    invalid_fixtures.each do |fixture|
      it "returns a string saying so" do
        result = Validator.validate(fixture)
        puts result
        expect(result).to(
          eq("This sudoku is invalid."),
          "Expected #{fixture} to be invalid but it wasn't."
        )
      end
    end
  end
end
