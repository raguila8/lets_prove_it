require 'rails_helper'

RSpec.describe User do
  let (:user) { build_stubbed(:user) }

  describe "username" do
    it "should not be nil" do
      user.username = nil
      expect(user.valid?).not_to be_truthy
      user.username = "rodrigo"
      expect(user.valid?).to be_truthy
    end

    it "should not have an empty username" do
      user.username = ""
      expect(user.valid?).not_to be_truthy
    end

    it "should have a username of length at least 5" do
      user.username = "a" * 4
      expect(user.valid?).not_to be_truthy
      user.username = "a" * 5
      expect(user.valid?).to be_truthy
    end

    it "should have a username of length at most 18" do
      user.username = "a" * 18
      expect(user.valid?).to be_truthy
      user.username = "a" * 19
      expect(user.valid?).not_to be_truthy
    end

    it "should be unique" do
      create(:user, username: "foobar")
      user.username = "foobar"
      expect(user.valid?).not_to be_truthy
      user.username = "FOOBAR"
      expect(user.valid?).not_to be_truthy    # username is case insensitive
    end
  end

  describe "email" do
    it "should not be nil" do
      user.email = nil
      expect(user.valid?).not_to be_truthy
    end

    it "should not be empty" do
      user.email = ""
      expect(user.valid?).not_to be_truthy
    end

    it "should not be longer than 255 characters" do
      user.email = "a" * 244 + "@example.com"
      expect(user.valid?).not_to be_truthy
    end

    it "should have valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to be_truthy, 
             "#{valid_address.inspect} should be valid"
      end
    end

    it "should not have invalid addresses" do
      invalid_addresses = %w[user@example,com 
                             user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).not_to be_truthy, 
             "#{invalid_address.inspect} should be invalid"
      end
    end

    it "should be unique" do
      create(:user, email: "foobar@example.com")
      user.email = "FOOBAR@EXAMPLE.COM"    # case insensitive
      expect(user.valid?).not_to be_truthy 
    end
  end

  describe "bio" do
    it "should not be longer than 500" do
      user.bio = "a" * 501
      expect(user.valid?).not_to be_truthy 
    end

    it "should have a length less than or equal to 500" do
      bio = "a"
      10.times do
        n = Random.rand(500) + 1
        user.bio = bio * n
        expect(user.valid?).to be_truthy,
          "Bio length: #{n} should be less than or equal to 500"
      end
    end
  end

  describe "name" do
    it "should not be longer than 70" do
      user.name = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end

    it "should have a name less than or equal to 70" do
      name = "a"
      10.times do
        n = Random.rand(70) + 1
        user.name = name * n
        expect(user.valid?).to be_truthy,
          "Name length: #{n} should be less than or equal to 70"
      end
    end
  end

  describe "occupation" do
    it "should not be longer than 70" do
      user.occupation = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end

    it "should have a length less than or equal to 70" do
      occupation = "a"
      10.times do
        n = Random.rand(70) + 1
        user.occupation = occupation * n
        expect(user.valid?).to be_truthy,
          "Occupation length: #{n} should be less than or equal to 70"
      end
    end
  end

  describe "education" do
    it "should not be longer than 70" do
      user.education = "a" * 71
      expect(user.valid?).not_to be_truthy 
    end

    it "should have a length less than or equal to 70" do
      education = "a"
      10.times do
        n = Random.rand(70) + 1
        user.education = education * n
        expect(user.valid?).to be_truthy,
          "Education length: #{n} should be less than or equal to 70"
      end
    end
  end

  describe "reputation" do
    it "should not be nil" do
      user.reputation = nil
      expect(user.valid?).not_to be_truthy
      user.reputation = 0
      expect(user.valid?).to be_truthy
    end

    it "should not be empty" do
      user.reputation = ""
      expect(user.valid?).not_to be_truthy
    end

    it "should not be a string" do
      user.reputation = "four"
      expect(user.valid?).not_to be_truthy
    end

    it "should not have invalid values" do
      invalid_values = [12.4, 90.00001, -1, 0.01, 20.02]
      invalid_values.each do |invalid_value|
        user.reputation = invalid_value
        expect(user.valid?).not_to be_truthy, 
             "#{invalid_value.inspect} should not be valid"
      end
    end

    it "should accept the set of natural numbers (including 0)" do
      valid_values = [0, 1, 2, 100, 1000, 999999, 2830917348, '32', 1.0]
      valid_values.each do |valid_value|
        user.reputation = valid_value
        expect(user.valid?).to be_truthy, 
             "#{valid_value.inspect} should be valid"
      end
    end
  end
end
