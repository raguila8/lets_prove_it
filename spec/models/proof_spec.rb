require 'rails_helper'

RSpec.describe Problem do

  describe "content" do
    let(:proof) { build_stubbed(:proof, problem: problem, user: user) }
    let(:user) { build_stubbed(:user) }
    let(:problem) { build_stubbed(:problem, user: other_user, topics: [topic]) }
    let(:other_user) { build_stubbed(:other_user) }
    let(:topic) { build_stubbed(:topic) }

    it "should not be nil" do
      proof.content = nil
      expect(proof.valid?).not_to be_truthy
      proof.content = "This is the proof's content..."
      expect(proof.valid?).to be_truthy
    end

    it "should not be empty" do
      proof.content = ""
      expect(proof.valid?).not_to be_truthy
    end

    it "should be at least 15 characters" do
      proof.content = "a" * 14
      expect(proof.valid?).not_to be_truthy
      proof.content = "a" * 15
      expect(proof.valid?).to be_truthy
    end

    it "should be at most 5000 characters long" do
      proof.content = "a" * 5001
      expect(proof.valid?).not_to be_truthy
      proof.content = "a" * 5000
      expect(proof.valid?).to be_truthy
    end

  end

  describe "uniquness of user and problem" do
    let(:proof) { create(:proof, problem: problem, user: user) }
    let(:user) { create(:user) }
    let(:problem) { create(:problem, user: other_user, topics: [topic]) }
    let(:other_user) { create(:other_user) }
    let(:topic) { create(:topic) }

    it "should have have unique user/problem pair" do
      other_proof = build_stubbed(:other_proof, user: proof.user, 
                                  problem: proof.problem)
      expect(other_proof.valid?).not_to be_truthy
      other_proof.user = other_user
      expect(other_proof.valid?).to be_truthy
    end
  end
end

