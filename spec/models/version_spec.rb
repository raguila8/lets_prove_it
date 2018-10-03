require 'rails_helper'

RSpec.describe Version do
  let(:version) { build_stubbed(:version, versioned: topic, user: user) }
  let(:topic) { build_stubbed(:topic) }
  let(:user) { build_stubbed(:user) }

  describe "title" do
    it "should not be nil" do
      version.title = nil
      expect(version.valid?).not_to be_truthy
      version.title = "This is a Proper Title"
      expect(version.valid?).to be_truthy
    end

    it "should not be empty" do
      version.title = ""
      expect(version.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      version.title = "a" * 2
      expect(version.valid?).not_to be_truthy
      version.title = "a" * 3
      expect(version.valid?).to be_truthy
    end

    it "should have a title of length at most 255" do
      version.title = "a" * 255
      expect(version.valid?).to be_truthy
      version.title = "a" * 256
      expect(version.valid?).not_to be_truthy
    end 
  end

  describe "content" do
    it "should not be nil" do
      version.content = nil
      expect(version.valid?).not_to be_truthy
      version.content = "This is the topic's content..."
      expect(version.valid?).to be_truthy
    end

    it "should not be empty" do
      version.content = ""
      expect(version.valid?).not_to be_truthy
    end

    it "should be at least 15 characters" do
      version.content = "a" * 14
      expect(version.valid?).not_to be_truthy
      version.content = "a" * 15
      expect(version.valid?).to be_truthy
    end

    it "should be at most 10000 characters long" do
      version.content = "a" * 10001
      expect(version.valid?).not_to be_truthy
      version.content = "a" * 5000
      expect(version.valid?).to be_truthy
    end
  end

  describe "description" do
    it "should not be nil" do
      version.description = nil
      expect(version.valid?).not_to be_truthy
      version.description = "This is the description of the edit..."
      expect(version.valid?).to be_truthy
    end

    it "should not be empty" do
      version.description = ""
      expect(version.valid?).not_to be_truthy
    end

    it "should be at least 10 characters" do
      version.description = "a" * 9
      expect(version.valid?).not_to be_truthy
      version.description = "a" * 10
      expect(version.valid?).to be_truthy
    end

    it "should be at most 750 characters long" do
      version.description = "a" * 751
      expect(version.valid?).not_to be_truthy
      version.description = "a" * 750
      expect(version.valid?).to be_truthy
    end
  end

  describe "version_number" do
    it "should not be nil" do
      version.version_number = nil
      expect(version.valid?).not_to be_truthy
      version.version_number = 1
      expect(version.valid?).to be_truthy
    end

    it "should not be empty" do
      version.version_number = ""
      expect(version.valid?).not_to be_truthy
    end

    it "should not be a string" do
      version.version_number = "four"
      expect(version.valid?).not_to be_truthy
    end

    it "should not have invalid values" do
      invalid_values = [12.4, 90.00001, -1, 0.01, 20.02, 0]
      invalid_values.each do |invalid_value|
        version.version_number = invalid_value
        expect(version.valid?).not_to be_truthy, 
             "#{invalid_value.inspect} should not be valid"
      end
    end

    it "should accept the set of natural numbers (not including 0)" do
      valid_values = [1, 2, 100, 1000, 999999, 2830917348, '32', 1.0]
      valid_values.each do |valid_value|
        version.version_number = valid_value
        expect(version.valid?).to be_truthy, 
             "#{valid_value.inspect} should be valid"
      end
    end

    it "should be unique for each versioned model" do
      create(:version, versioned: topic, user: user, version_number: 1)
      version.version_number = 1
      expect(version.valid?).not_to be_truthy
      version.version_number = 2
      expect(version.valid?).to be_truthy
    end
  end
end

