require 'rails_helper'

RSpec.describe Flag do
  let (:flag) { build_stubbed(:flag) }

  describe "name" do
    it "should not be nil" do
      flag.name = nil
      expect(flag.valid?).not_to be_truthy
      flag.name = "foobar"
      expect(flag.valid?).to be_truthy
    end

    it "should not have an empty name" do
      flag.name = ""
      expect(flag.valid?).not_to be_truthy
    end

    it "should have a name of length at least 3" do
      flag.name = "a" * 2
      expect(flag.valid?).not_to be_truthy
      flag.name = "a" * 3
      expect(flag.valid?).to be_truthy
    end

    it "should be unique" do
      create(:flag, name: "random")
      flag.name = "random"
      expect(flag.valid?).not_to be_truthy
    end
  end

  describe "reportable_type" do
    it "should not be nil" do
      flag.reportable_type = nil
      expect(flag.valid?).not_to be_truthy
      flag.reportable_type = "problem"
      expect(flag.valid?).to be_truthy
    end

    it "should not have an empty reportable_type" do
      flag.reportable_type = ""
      expect(flag.valid?).not_to be_truthy
    end

    it "should be either 'all', 'problem', 'comment', 'proof' or 'problem and proof'" do
      valid_types = ['all', 'problem', 'comment', 'proof', 'problem and proof']
      valid_types.each do |valid_type|
        flag.reportable_type = valid_type
        expect(flag.valid?).to be_truthy, 
                                 "#{valid_type.inspect} should be valid"
      end
    end

    it "should not have an invalid reportable_type" do
      invalid_types = ['topic', 'tag', 'user', 'Problem', 'comment and problem']
      invalid_types.each do |invalid_type|
        flag.reportable_type = invalid_type
        expect(flag.valid?).not_to be_truthy, 
                                 "#{invalid_type.inspect} should be invalid"
      end
    end
  end

  describe "description" do
    it "should not be nil" do
      flag.description = nil
      expect(flag.valid?).not_to be_truthy
      flag.description = "Content that is spam..."
      expect(flag.valid?).to be_truthy
    end

    it "should not have an empty description" do
      flag.description = ""
      expect(flag.valid?).not_to be_truthy
    end
  end
end

