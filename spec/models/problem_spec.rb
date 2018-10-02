require 'rails_helper'

RSpec.describe Problem do
  let (:problem) { build_stubbed(:problem, user: user, topics: [topic]) }
  let (:user) { build_stubbed(:user) }
  let (:topic) { build_stubbed(:topic) }

  describe "title" do
    it "should not be nil" do
      problem.title = nil
      expect(problem.valid?).not_to be_truthy
      problem.title = "This is a Proper Title"
      expect(problem.valid?).to be_truthy
    end

    it "should not be empty" do
      problem.title = ""
      expect(problem.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      problem.title = "a" * 2
      expect(problem.valid?).not_to be_truthy
      problem.title = "a" * 3
      expect(problem.valid?).to be_truthy
    end

    it "should have a title of length at most 255" do
      problem.title = "a" * 255
      expect(problem.valid?).to be_truthy
      problem.title = "a" * 256
      expect(problem.valid?).not_to be_truthy
    end

    it "should be unique" do
      other_user = create(:other_user)
      other_topic = create(:other_topic)
      create(:other_problem, title: "foobar", user: other_user, topics: [other_topic])
      problem.title = "foobar"
      expect(problem.valid?).not_to be_truthy
      problem.title = "FOOBAR"
      expect(problem.valid?).not_to be_truthy    # title is case insensitive
      problem.title = "foobar2"
      expect(problem.valid?).to be_truthy
    end
  end

  describe "content" do
    it "should not be nil" do
      problem.content = nil
      expect(problem.valid?).not_to be_truthy
      problem.content = "This is the problem content..."
      expect(problem.valid?).to be_truthy
    end

    it "should not be empty" do
      problem.content = ""
      expect(problem.valid?).not_to be_truthy
    end

    it "should be at least 15 characters" do
      problem.content = "a" * 14
      expect(problem.valid?).not_to be_truthy
      problem.content = "a" * 15
      expect(problem.valid?).to be_truthy
    end

    it "should be at most 5000 characters long" do
      problem.content = "a" * 5001
      expect(problem.valid?).not_to be_truthy
      problem.content = "a" * 5000
      expect(problem.valid?).to be_truthy
    end
  end

  describe "cached_proofs_count" do
    it "should not be nil" do
      problem.cached_proofs_count = nil
      expect(problem.valid?).not_to be_truthy
      problem.cached_proofs_count = 5
      expect(problem.valid?).to be_truthy
    end

    it "should not be empty" do
      problem.cached_proofs_count = ""
      expect(problem.valid?).not_to be_truthy
    end

    it "should not be a string" do
      problem.cached_proofs_count = "four"
      expect(problem.valid?).not_to be_truthy
    end

    it "should not have invalid values" do
      invalid_values = [12.4, 90.00001, -1, 0.01, 20.02]
      invalid_values.each do |invalid_value|
        problem.cached_proofs_count = invalid_value
        expect(problem.valid?).not_to be_truthy, 
             "#{invalid_value.inspect} should not be valid"
      end
    end

    it "should accept the set of natural numbers (including 0)" do
      valid_values = [0, 1, 2, 100, 1000, 999999, 2830917348, '32', 1.0]
      valid_values.each do |valid_value|
        problem.cached_proofs_count = valid_value
        expect(problem.valid?).to be_truthy, 
             "#{valid_value.inspect} should be valid"
      end
    end
  end

end

