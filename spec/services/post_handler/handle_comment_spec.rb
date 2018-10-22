require 'rails_helper'

include PostHandler

RSpec.describe PostHandler::HandlePost do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: user, 
                            topics: [topic]) }

  context "comment belongs to problem" do
    let(:comment) { create(:comment, user: user, commented_on: problem) }

    3.times do |n|
      reports_count = rand(3..6)
      score = rand(-1..10)
      it "should be soft deleted when it recieves #{reports_count} or more reports, and has a score of #{score}" do
        comment.update(cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: comment, user: create(:new_user),
                           flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to_not be_nil
      end
    end

    3.times do |n|
      score = rand(-20..-5)
      it "should be soft deleted when it has a score of #{score} or lower" do
        comment.update(cached_votes_score: score)

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to_not be_nil
      end
    end

    3.times do |n|
      score = rand(-4..20)
      reports_count = rand(0..2)

      it "should not soft delete comment when it recieves #{reports_count} #{"report".pluralize(reports_count)}, and has a score of #{score}" do
        comment.update(cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: comment, user: create(:new_user),
                           flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil
      end
    end
  end

  context "belongs to proof" do
    let(:proof) { create(:proof, user: user, problem: problem) }
    let(:comment) { create(:comment, user: user, commented_on: proof) }

    3.times do |n|
      reports_count = rand(3..6)
      score = rand(-1..10)
      it "should be soft deleted when it recieves #{reports_count} or more reports, and has a score of #{score}" do
        comment.update(cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: comment, user: create(:new_user),
                           flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to_not be_nil
      end
    end

    3.times do |n|
      score = rand(-20..-5)
      it "should be soft deleted when it has a score of #{score} or lower" do
        comment.update(cached_votes_score: score)

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to_not be_nil
      end
    end

    3.times do |n|
      score = rand(-4..20)
      reports_count = rand(0..2)

      it "should not soft delete comment when it recieves #{reports_count} #{"report".pluralize(reports_count)}, and has a score of #{score}" do
        comment.update(cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: comment, user: create(:new_user),
                           flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil

        HandlePost.new(post: comment, handle: :all).call

        expect(Comment.count).to eq(1)
        expect(comment.deleted_on).to be_nil
      end
    end
  end
end
