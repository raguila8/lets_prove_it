require 'rails_helper'

RSpec.describe Vote do
  let(:voter) { create(:user) }
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:proof) { create(:proof, problem: problem, user: other_user) }
  let(:comment) { create(:comment, commented_on: proof, user: other_user) }

  it "should not be able to upvote their own problems" do
    problem.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(problem.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: problem, vote_type: "like").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(problem.cached_votes_score).to eq(0)
  end

  it "should not be able to upvote their own proofs" do
    proof.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(proof.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: proof, vote_type: "like").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(proof.cached_votes_score).to eq(0)
  end

  it "should not be able to upvote their own comments" do
    comment.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(comment.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: comment, vote_type: "like").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(comment.cached_votes_score).to eq(0)
  end

  it "should not be able to downvote their own problems" do
    problem.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(problem.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(problem.cached_votes_score).to eq(0)
  end

  it "should not be able to downvote their own proofs" do
    proof.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(proof.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(proof.cached_votes_score).to eq(0)
  end

  it "should not be able to downvote their own comments" do
    comment.update(user: voter)
    voter.update(reputation: rand(0...25000))
    expect(comment.cached_votes_score).to eq(0)
    vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
    expect(vote.response).to eq(:error)
    expect(vote.action_taken).to eq(:none)
    expect(comment.cached_votes_score).to eq(0)
  end

  context "user with reputation < 10" do
    it "should not be able to upvote problems" do
      voter.update(reputation: rand(10))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(problem.cached_votes_score).to eq(0)
    end

    it "should not be able to upvote comments" do
      voter.update(reputation: rand(10))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(comment.cached_votes_score).to eq(0)
    end

    it "should not be able to upvote proofs" do
      voter.update(reputation: rand(10))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(proof.cached_votes_score).to eq(0)
    end

    it "should not be able to downvote problems" do
      voter.update(reputation: rand(10))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(problem.cached_votes_score).to eq(0)
    end

    it "should not be able to downvote proofs" do
      voter.update(reputation: rand(10))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(proof.cached_votes_score).to eq(0)
    end

    it "should not be able to downvote comments" do
      voter.update(reputation: rand(10))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(comment.cached_votes_score).to eq(0)
    end
  end

  context "user with reputation >= 10 but < 200" do
    it "should be able to upvote problems" do
      voter.update(reputation: rand(10...200))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(problem.cached_votes_score).to eq(1)
    end

    it "should be able to upvote proofs" do
      voter.update(reputation: rand(10...200))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(proof.cached_votes_score).to eq(1)
    end

    it "should be able to upvote comments" do
      voter.update(reputation: rand(10...200))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(comment.cached_votes_score).to eq(1)

    end

    it "should be able to unlike problem" do
      voter.update(reputation: rand(10...200))
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(problem.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(problem.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end

    it "should be able to unlike proofs" do
      voter.update(reputation: rand(10...200))
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(proof.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(proof.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end
 
    it "should be able to unlike comments" do
      voter.update(reputation: rand(10...200))
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(comment.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(comment.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end
 
    it "should not be able to downvote problems" do
      voter.update(reputation: rand(10...200))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(problem.cached_votes_score).to eq(0)
    end

    it "should not be able to downvote proofs" do
      voter.update(reputation: rand(10...200))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(proof.cached_votes_score).to eq(0)
    end

    it "should not be able to downvote comments" do
      voter.update(reputation: rand(10...200))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(vote.response).to eq(:error)
      expect(vote.action_taken).to eq(:none)
      expect(comment.cached_votes_score).to eq(0) 
    end
  end

  context "user with reputation >= 200" do
    it "should be able to upvote problems" do
      voter.update(reputation: rand(200...25000))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(problem.cached_votes_score).to eq(1)
    end

    it "should be able to upvote proofs" do
      voter.update(reputation: rand(200...25000))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(proof.cached_votes_score).to eq(1)
    end

    it "should be able to upvote comments" do
      voter.update(reputation: rand(200...25000))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:like)
      expect(comment.cached_votes_score).to eq(1)
    end


    it "should be able to downvote problems" do
      voter.update(reputation: rand(200...25000))
      expect(problem.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:dislike)
      expect(problem.cached_votes_score).to eq(-1)
    end

    it "should be able to downvote proofs" do
      voter.update(reputation: rand(200...25000))
      expect(proof.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:dislike)
      expect(proof.cached_votes_score).to eq(-1)
    end

    it "should be able to downvote comments" do
      voter.update(reputation: rand(200...25000))
      expect(comment.cached_votes_score).to eq(0)
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:dislike)
      expect(comment.cached_votes_score).to eq(-1)
    end

    it "should be able to unlike problem" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(problem.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(problem.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end

    it "should be able to unlike proofs" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(proof.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(proof.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end
 
    it "should be able to unlike comments" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(comment.cached_votes_score).to eq(1)
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(comment.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:unlike)
    end

    it "should be able to undislike problems" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: problem, vote_type: "dislike").call
      expect(problem.cached_votes_score).to eq(-1)
      vote = Vote.new(user: voter, post: problem, vote_type: "like").call
      expect(problem.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:undislike)
    end

    it "should be able to undislike proofs" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: proof, vote_type: "dislike").call
      expect(proof.cached_votes_score).to eq(-1)
      vote = Vote.new(user: voter, post: proof, vote_type: "like").call
      expect(proof.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:undislike)
    end

    it "should be able to undislike comments" do
      voter.update(reputation: rand(200...25000))
      vote = Vote.new(user: voter, post: comment, vote_type: "dislike").call
      expect(comment.cached_votes_score).to eq(-1)
      vote = Vote.new(user: voter, post: comment, vote_type: "like").call
      expect(comment.cached_votes_score).to eq(0)
      expect(vote.response).to eq(:success)
      expect(vote.action_taken).to eq(:undislike)
    end
  end
end
