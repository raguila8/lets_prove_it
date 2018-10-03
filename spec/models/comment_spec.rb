require 'rails_helper'

RSpec.describe Comment do
  let(:proof_comment) { build_stubbed(:comment, commented_on: proof, user: user) }
  let(:proof) { build_stubbed(:proof, problem: problem, user: other_user) }
  let(:problem) { build_stubbed(:problem, user: other_user) }
  let(:user) { build_stubbed(:user, reputation: 50) }
  let(:other_user) { build_stubbed(:other_user) }

  describe "content" do
    it "should not be nil" do
      proof_comment.content = nil
      expect(proof_comment.valid?).not_to be_truthy
      proof_comment.content = "This is the comment's content..."
      expect(proof_comment.valid?).to be_truthy
    end

    it "should not be empty" do
      proof_comment.content = ""
      expect(proof_comment.valid?).not_to be_truthy
    end

    it "should be at least 3 characters" do
      proof_comment.content = "a" * 2
      expect(proof_comment.valid?).not_to be_truthy
      proof_comment.content = "a" * 3
      expect(proof_comment.valid?).to be_truthy
    end

    it "should be at most 500 characters long" do
      proof_comment.content = "a" * 501
      expect(proof_comment.valid?).not_to be_truthy
      proof_comment.content = "a" * 500
      expect(proof_comment.valid?).to be_truthy
    end
  end

  describe "user privilige" do
    it "should be at least 50" do
      proof_comment.user.reputation = 49
      expect(proof_comment.valid?).not_to be_truthy
      proof_comment.user.reputation = 50
      expect(proof_comment.valid?).to be_truthy
    end
  end

  describe "commented_on" do
    it "should be either a proof or problem" do
      valid_models = [proof, problem]
      valid_models.each do |valid_model|
        proof_comment.commented_on = valid_model
        expect(proof_comment.valid?).to be_truthy, 
                 "#{proof_comment.commented_on_type} should be commented_on"
      end
    end

    it "should not have invalid commented_on models" do
      topic = build_stubbed(:topic)
      invalid_models = [topic, proof_comment]
      invalid_models.each do |invalid_model|
        proof_comment.commented_on = invalid_model
        expect(proof_comment.valid?).not_to be_truthy,
         "#{invalid_model.class.name.inspect} model should not be commented_on"
      end
    end
  end
end
