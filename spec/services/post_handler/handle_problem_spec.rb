require 'rails_helper'

include PostHandler

RSpec.describe PostHandler::HandlePost do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  
  context "problem is dead (over 60 days old, score of 0 or less, 0 proofs and 0 reports)" do
    let!(:problem) { create(:problem, user: user, 
                            topics: [topic], 
                            cached_votes_score: 0, 
                            created_at: 61.days.ago) }

    3.times do |n|
      days_count = rand(60..1000)
      score = rand(-5..0)
      it "should be deleted when problem is #{days_count} days old, score of #{score}, and 0 proofs, and 0 reports" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)
        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to_not be_nil
      end
    end
  end

  context "problem is old and poor (over 30 days old, with 3 or more reports and 0 proofs)" do
    let!(:problem) { create(:problem, user: user, 
                            topics: [topic], 
                            cached_votes_score: 0, 
                            created_at: 61.days.ago ) }

    3.times do |n|
      days_count = rand(31..60)
      reports_count = rand(3..5)
      score = rand(-10..10)
      it "should be deleted when it is #{days_count} days old, has #{reports_count} reports, a score of #{score} and 0 proofs" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: problem, user: create(:new_user),
                                 flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to_not be_nil
      end
    end

  end

  context "problem was flagged as spam or offensive 6 or more times" do
    fixtures :flags
    let!(:problem) { create(:problem, user: user, 
                            topics: [topic], 
                            cached_votes_score: 5) }
    before(:each) do
      @spam_and_offensive_flags = [Flag.first, Flag.second]
    end

    3.times do |n|
      reports_count = rand(6..10)
      proofs_count = rand(0..5)
      it "should be deleted when it has #{reports_count} spam/offensive flags and #{proofs_count} #{"proof".pluralize(proofs_count)}" do
        reports_count.times do |i|
          report = create(:random_report, reportable: problem, user: create(:new_user))
          @spam_and_offensive_flags.sample(rand(1..2)).each do |flag|
            FlagReport.create(report: report, flag: flag)
          end
        end

        proofs_count.times do |i|
          create(:proof, content: Faker::Lorem.paragraph, problem: problem,
                                    user: create(:new_user))
        end

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to_not be_nil
      end
    end

    it "should remove 100 reputation from owner of problem" do
      reputation_before_flags = problem.user.reputation
      6.times do |i|
        report = create(:random_report, reportable: problem, user: create(:new_user))
        @spam_and_offensive_flags.sample(rand(1..2)).each do |flag|
          FlagReport.create(report: report, flag: flag)
        end
      end

      PostHandler::HandlePost.new(post: problem, handle: :all).call
      expect(problem.user.reputation).to eq(reputation_before_flags - 100)
    end
  end

  context "valid problem" do
    fixtures :flags
    let!(:problem) { create(:problem, user: user, 
                            topics: [topic], 
                            cached_votes_score: 0) }

    # age is less than 60 days, and score is positive
    3.times do |n|
      days_count = rand(0..59)
      score = rand(1..20)
      it "should not be deleted when problem is #{days_count} days old, score of #{score}, and 0 proofs, and 0 reports" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)
        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is older than 60 days, but score is positive
    3.times do |n|
      days_count = rand(60..500)
      score = rand(1..20)
      it "should not be deleted when problem is #{days_count} days old, score of #{score}, and 0 proofs, and 0 reports" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)
        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is not older than 60 days, but score is 0 or less
    3.times do |n|
      days_count = rand(0..59)
      score = rand(-5..0)
      it "should not be deleted when problem is #{days_count} days old, score of #{score}, and 0 proofs, and 0 reports" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)
        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    #problem is older than 60 days, score is 0 or less, but has at least 1 proof
    3.times do |n|
      days_count = rand(60..500)
      score = rand(-5..0)
      proofs_count = rand(1..5)
      it "should not be deleted when problem is #{days_count} days old, score of #{score}, and #{proofs_count} #{"proof".pluralize(proofs_count)}, and 0 reports" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        proofs_count.times do |i|
          create(:proof, content: Faker::Lorem.paragraph, problem: problem,
                                    user: create(:new_user))
        end

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is older than 30 days but less than 60, but has less than 3 reports and 0 proofs
    3.times do |n|
      days_count = rand(31..59)
      reports_count = rand(0..2)
      score = rand(-10..10)
      it "should not be deleted when it is #{days_count} days old, has #{reports_count} #{"report".pluralize(reports_count)}, a score of #{score} and 0 proofs" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: problem, user: create(:new_user),
                                 flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is less than 30 days old, but has 3 or more reports and 0 proofs
    3.times do |n|
      days_count = rand(0..29)
      reports_count = rand(3..5)
      score = rand(-10..10)
      it "should not be deleted when it is #{days_count} days old, has #{reports_count} reports, a score of #{score} and 0 proofs" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: problem, user: create(:new_user),
                                 flags: Flag.all.sample(rand(Flag.count)))
        end

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is older than 30 days but less than 60, has 3 or more reports, but 1 or more proofs
    3.times do |n|
      days_count = rand(31..60)
      reports_count = rand(3..5)
      score = rand(-10..10)
      proofs_count = rand(1..5)
      it "should not be deleted when it is #{days_count} days old, has #{reports_count} reports, a score of #{score} and #{proofs_count} #{"proof".pluralize(proofs_count)}" do
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: problem, user: create(:new_user),
                                 flags: Flag.all.sample(rand(Flag.count)))
        end

        proofs_count.times do |i|
          create(:proof, content: Faker::Lorem.paragraph, problem: problem,
                                    user: create(:new_user))
        end


        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end

    # problem is older than 30 days but less than 60, has 3 or more reports, but 1 or more proofs
    3.times do |n|
      days_count = rand(0..29)
      reports_count = rand(1..5)
      score = rand(-10..10)
      proofs_count = rand(1..5)
      it "should not be deleted when it is #{days_count} days old, has #{reports_count} spam/offensive flags, a score of #{score} and #{proofs_count} #{"proof".pluralize(proofs_count)}" do
        @spam_and_offensive_flags = [Flag.first, Flag.second]
        problem.update(created_at: days_count.days.ago, 
                       cached_votes_score: score)

        reports_count.times do |i|
          create(:random_report, reportable: problem, user: create(:new_user),
                                 flags: @spam_and_offensive_flags.sample(rand(1..2)))
        end

        proofs_count.times do |i|
          create(:proof, content: Faker::Lorem.paragraph, problem: problem,
                                    user: create(:new_user))
        end


        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil

        HandlePost.new(post: problem, handle: :all).call

        expect(Problem.count).to eq(1)
        expect(problem.deleted_on).to be_nil
      end
    end


  end 
end
