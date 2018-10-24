require 'rails_helper'

include PostHandler

RSpec.describe PostHandler::HandlePost do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: user, 
                            topics: [topic]) }

  context "proof with 6 or more offensive/spam flags" do
    let!(:proof) { create(:proof, user: user, problem: problem) }
    before(:each) do
      @spam_and_offensive_flags = [Flag.first, Flag.second]
    end

    3.times do |n|
      reports_count = rand(6..10)
      score = rand(-10..10)
      it "should be deleted when it has #{reports_count} spam/offensive flags, and a score of #{score}" do
        proof.update(cached_votes_score: score)
        reports_count.times do |i|
          create(:random_report, reportable: proof, user: create(:new_user),
                           flags: @spam_and_offensive_flags.sample(rand(1..2)))
        end

        expect(Proof.count).to eq(1)
        expect(proof.deleted_on).to be_nil

        HandlePost.new(post: proof, handle: :all).call

        expect(Proof.count).to eq(1)
        expect(proof.deleted_on).to_not be_nil
      end
    end

    it "should remove 100 reputation from owner of proof" do
      reputation_before_flags = proof.user.reputation
      6.times do |i|
        report = create(:random_report, reportable: proof, user: create(:new_user))
        @spam_and_offensive_flags.sample(rand(1..2)).each do |flag|
          FlagReport.create(report: report, flag: flag)
        end
      end
      PostHandler::HandlePost.new(post: proof, handle: :all).call
      expect(proof.user.reputation).to eq(reputation_before_flags - 100)
    end

  end

  context "proof with score of -4 or less" do
    let!(:proof) { create(:proof, user: user, problem: problem) }

  end

  context "valid proof" do
    let!(:proof) { create(:proof, user: user, problem: problem) }

    3.times do |n|
      reports_count = rand(1..5)
      score = rand(-10..10)
      it "should not be deleted when it has #{reports_count} spam/offensive flags, and a score of #{score}" do
        @spam_and_offensive_flags = [Flag.first, Flag.second]
        proof.update(cached_votes_score: score)
        reports_count.times do |i|
          create(:random_report, reportable: proof, user: create(:new_user),
                           flags: @spam_and_offensive_flags.sample(rand(1..2)))
        end

        expect(Proof.count).to eq(1)
        expect(proof.deleted_on).to be_nil

        HandlePost.new(post: proof, handle: :all).call

        expect(Proof.count).to eq(1)
        expect(proof.deleted_on).to be_nil
      end
    end

    

  end

  

end
