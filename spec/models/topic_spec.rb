require 'rails_helper'

RSpec.describe Topic do
  let (:topic) { build_stubbed(:topic) }
  
  describe "name" do
    it "should not be nil" do
      topic.name = nil
      expect(topic.valid?).not_to be_truthy
      topic.name = "algebra"
      expect(topic.valid?).to be_truthy
    end

    it "should not have an empty name" do
      topic.name = ""
      expect(topic.valid?).not_to be_truthy
    end

    it "should have a name of length at least 3" do
      topic.name = "a" * 2
      expect(topic.valid?).not_to be_truthy
      topic.name = "a" * 3
      expect(topic.valid?).to be_truthy
    end

    it "should have a name of length at most 35" do
      topic.name = "a" * 35
      expect(topic.valid?).to be_truthy
      topic.name = "a" * 36
      expect(topic.valid?).not_to be_truthy
    end

    it "should be unique" do
      create(:other_topic, name: "foobar")
      topic.name = "foobar"
      expect(topic.valid?).not_to be_truthy
      topic.name = "FOOBAR"
      expect(topic.valid?).not_to be_truthy    # name is case insensitive
    end

    it "should have a valid name" do
      valid_names = ['name', '123name', '#name', 'name-11', 'valid+name', 'valid.name-1+2#']
      valid_names.each do |valid_name|
        topic.name = valid_name
        expect(topic.valid?).to be_truthy, 
             "#{valid_name.inspect} should be valid"
      end
    end

    it "should not have an invalid name" do
      invalid_names = ['name!', '123Name', '#(name)', '$name$-11', 
                       '@valid+name', 'valid name', 'valid_name', '*name', 
                       'name^name', 'NAME', '%name', "'name'", 'name?']
      invalid_names.each do |invalid_name|
        topic.name = invalid_name
        expect(topic.valid?).not_to be_truthy, 
             "#{invalid_name.inspect} should not be valid"
      end
    end
  end

  describe "description" do
    it "should not be nil" do
      topic.description = nil
      expect(topic.valid?).not_to be_truthy
      topic.description = "This is a description that describes the topic..."
      expect(topic.valid?).to be_truthy
    end

    it "should not be empty" do
      topic.description = ""
      expect(topic.valid?).not_to be_truthy
    end

    it "should be at least 35 characters" do
      topic.description = "a" * 34
      expect(topic.valid?).not_to be_truthy
      topic.description = "a" * 35
      expect(topic.valid?).to be_truthy
    end

    it "should have a length of 10000 at most" do
      topic.description = "a" * 10001
      expect(topic.valid?).not_to be_truthy
      topic.description = "a" * 10000
      expect(topic.valid?).to be_truthy
    end
  end

  describe "cached_problems_count" do
    it "should not be nil" do
      topic.cached_problems_count = nil
      expect(topic.valid?).not_to be_truthy
      topic.cached_problems_count = 5
      expect(topic.valid?).to be_truthy
    end

    it "should not be empty" do
      topic.cached_problems_count = ""
      expect(topic.valid?).not_to be_truthy
    end

    it "should not be a string" do
      topic.cached_problems_count = "four"
      expect(topic.valid?).not_to be_truthy
    end

    it "should not have invalid values" do
      invalid_values = [12.4, 90.00001, -1, 0.01, 20.02]
      invalid_values.each do |invalid_value|
        topic.cached_problems_count = invalid_value
        expect(topic.valid?).not_to be_truthy, 
             "#{invalid_value.inspect} should not be valid"
      end
    end

    it "should accept the set of natural numbers (including 0)" do
      valid_values = [0, 1, 2, 100, 1000, 999999, 2830917348, '32', 1.0]
      valid_values.each do |valid_value|
        topic.cached_problems_count = valid_value
        expect(topic.valid?).to be_truthy, 
             "#{valid_value.inspect} should be valid"
      end
    end
  end
end
