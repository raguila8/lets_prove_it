require 'rails_helper'

RSpec.describe Vote do
  let(:voter) { create(:user) }
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user) }
  let(:topic) { create(:topic) }
  let(:proof) { create(:proof, problem: problem, user: other_user) }
  let(:comment) { create(:comment, commented_on: proof, user: other_user) }

  context "user with reputation < 10" do
    it "should not be able to upvote posts" do
        
    end

    it "should not be able to downvote posts" do

    end
  end

  context "user with reputation >= 10 but < 100" do
    it "should be able to upvote posts" do
        
    end

    it "should be able to unlike posts" do

    end

    it "should not be able to upvote their own posts" do

    end

    it "should not be able to downvote posts" do

    end
  end

  context "user with reputation >= 100" do
    it "should be able to upvote posts" do

    end

    it "should be able to downvote posts" do

    end

    it "should not be able to upvote posts" do

    end

    it "should not be able to downvote posts" do

    end
  end
end

