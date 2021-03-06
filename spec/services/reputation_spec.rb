require 'rails_helper'

RSpec.describe Reputation do
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:proof) { create(:proof, problem: problem, user: other_user) }
  let(:comment) { create(:comment, commented_on: proof, user: other_user) }


  describe "voting" do
    let(:voter) { create(:user, reputation: 500) }
    describe "likes" do
      it "should earn user +5 for each upvote on their problems" do
        expect(problem.user.reputation).to eq(500)
        Vote.new(user: voter, post: problem, vote_type: "like").call
        expect(problem.user.reputation).to eq(505)
      end

      it "should earn user +10 for each upvote on their proofs" do
        expect(proof.user.reputation).to eq(500)
        Vote.new(user: voter, post: proof, vote_type: "like").call
        expect(proof.user.reputation).to eq(510)
      end

      it "should earn user +2 for each upvote on their comments" do
        expect(comment.user.reputation).to eq(500)
        Vote.new(user: voter, post: comment, vote_type: "like").call
        expect(comment.user.reputation).to eq(502)
      end

      it "should not affect voter's reputation when upvoting posts" do
        posts = [problem, comment, proof]
        posts.each do |post|
          expect(voter.reputation).to eq(500)
          Vote.new(user: voter, post: post, vote_type: "like").call
          expect(voter.reputation).to eq(500), 
           "Upvoting a #{post.class.name} should not affect voter's reputation"
        end
      end
    end

    describe "dislikes" do
      it "should decrease user's reputation by -2 when their problem is voted down" do
        expect(problem.user.reputation).to eq(500)
        Vote.new(user: voter, post: problem, vote_type: "dislike").call
        expect(problem.user.reputation).to eq(498)
      end

      it "should decrease user's reputation by -2 when their proof is voted down" do
        expect(proof.user.reputation).to eq(500)
        Vote.new(user: voter, post: proof, vote_type: "dislike").call
        expect(proof.user.reputation).to eq(498)
      end

      it "should decrease user's reputation by -1 when their proof is voted down" do
        expect(comment.user.reputation).to eq(500)
        Vote.new(user: voter, post: comment, vote_type: "dislike").call
        expect(comment.user.reputation).to eq(499)
      end

      it "should decrease voter's reputation by -1 when they vote down a problem or a proof" do
        posts = [problem, proof]
        expect(voter.reputation).to eq(500)
        posts.each do |post|
          voter_reputation = voter.reputation
          Vote.new(user: voter, post: post, vote_type: "dislike").call
          expect(voter.reputation).to eq(voter_reputation - 1), 
           "Downvoting a #{post.class.name} should give -1 reputation to the voter"
        end
      end

      it "should not affect the voter's reputation when they votedown a comment" do
        previous_reputation = voter.reputation
        Vote.new(user: voter, post: comment, vote_type: "dislike").call
        expect(voter.reputation).to eq(previous_reputation)
      end
    end

    describe "unlikes" do
      it "should give -5 reputation to user when their problem is unliked" do
        Vote.new(user: voter, post: problem, vote_type: "like").call
        expect(problem.user.reputation).to eq(505)
        Vote.new(user: voter, post: problem, vote_type: "dislike").call
        expect(problem.user.reputation).to eq(500)
      end

      it "should give -10 reputation to user when their proof is unliked" do
        Vote.new(user: voter, post: proof, vote_type: "like").call
        expect(proof.user.reputation).to eq(510)
        Vote.new(user: voter, post: proof, vote_type: "dislike").call
        expect(proof.user.reputation).to eq(500)
      end

      it "should give -2 reputation to user when their comment is unliked" do
        Vote.new(user: voter, post: comment, vote_type: "like").call
        expect(comment.user.reputation).to eq(502)
        Vote.new(user: voter, post: comment, vote_type: "dislike").call
        expect(comment.user.reputation).to eq(500)
      end

      it "should not affect voter's reputation when unliking a post" do
        posts = [problem, proof, comment]
        posts.each do |post|
          Vote.new(user: voter, post: post, vote_type: "like").call
          expect(voter.reputation).to eq(500)
          Vote.new(user: voter, post: post, vote_type: "dislike").call
          expect(voter.reputation).to eq(500), 
           "Unliking a #{post.class.name} should not affect voter's reputation"
        end
      end
    end

    describe "undislikes" do
      it "should give +2 reputation to user when their problem is undisliked" do
        Vote.new(user: voter, post: problem, vote_type: "dislike").call
        expect(problem.user.reputation).to eq(498)
        Vote.new(user: voter, post: problem, vote_type: "like").call
        expect(problem.user.reputation).to eq(500)
      end

      it "should give +2 reputation to user when their proof is undisliked" do
        Vote.new(user: voter, post: proof, vote_type: "dislike").call
        expect(proof.user.reputation).to eq(498)
        Vote.new(user: voter, post: proof, vote_type: "like").call
        expect(proof.user.reputation).to eq(500)

      end

      it "should give +1 reputation to user when their comment is undisliked" do
        Vote.new(user: voter, post: comment, vote_type: "dislike").call
        expect(comment.user.reputation).to eq(499)
        Vote.new(user: voter, post: comment, vote_type: "like").call
        expect(comment.user.reputation).to eq(500)
      end

      it "should give +1 reputation to voter when problem or proof is undisliked" do
        posts = [problem, proof]
        posts.each do |post|
          voter_reputation = voter.reputation
          Vote.new(user: voter, post: post, vote_type: "dislike").call
          expect(voter.reputation).to eq(voter_reputation - 1)
          new_voter_reputation = voter.reputation
          Vote.new(user: voter, post: post, vote_type: "like").call
          expect(voter.reputation).to eq(new_voter_reputation + 1),
            "Undisliking a #{post.class.name} should give +1 back to voter; expected 500, got #{voter.reputation}"
        end
      end

      it "should not affect the voter's reputation when they undislike a comment" do
        previous_reputation = voter.reputation
        Vote.new(user: voter, post: comment, vote_type: "undislike").call
        expect(voter.reputation).to eq(previous_reputation)
      end
    end

    describe "spam or offensive post takedowns" do
      it "should remove 100 reputation from users whose problem is deleted as a result of accumulation of spam/offensive flags" do
        reputation_before_flags = problem.user.reputation 
        Reputation::UpdateReputation.new(action: :spam_or_offensive_takedown,
                                          acted_on: problem).call
        expect(problem.user.reputation).to eq(reputation_before_flags - 100)
      end

      it "should remove 100 reputation from users whose proof is deleted as a result of accumulation of spam/offensive flags" do
        reputation_before_flags = proof.user.reputation
        Reputation::UpdateReputation.new(action: :spam_or_offensive_takedown,
                                          acted_on: proof).call
        expect(proof.user.reputation).to eq(reputation_before_flags - 100)
      end
    end
  end
end

