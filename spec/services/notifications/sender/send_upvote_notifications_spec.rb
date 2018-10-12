require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  describe "liking a problem" do
    before(:each) do
      create(:version, versioned: problem, 
                                   user: other_user, version_number: 1)
    end

    it "should return the correct feedback" do
      problem.liked_by actor
      feedback = SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to all previous problem editors" do
      problem.liked_by actor

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: other_user, actor: actor,
                                  notifiable: problem, 
                                  action_type: "like")).to_not be_nil

    end

    it "should not send a notification to voter even if they have edited the post before" do
      create(:version, versioned: problem, 
                                   user: actor, version_number: 2)
      
      problem.liked_by actor
      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: actor, actor: actor,
                                  notifiable: problem, 
                                  action_type: "like")).to be_nil
    end
  end

  describe "liking a proof" do
    let(:proof) { create(:proof, user: other_user, problem: problem) }
    before(:each) do
      create(:version, versioned: proof, 
                                   user: other_user, version_number: 1)
    end


    it "should return the correct feedback" do
      proof.liked_by actor
      feedback = SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to all previous proof editors" do
      proof.liked_by actor

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: other_user, actor: actor,
                                  notifiable: proof, 
                                  action_type: "like")).to_not be_nil
    end

    it "should not send a notification to voter even if they have edited the proof before" do
      create(:version, versioned: proof, 
                                   user: actor, version_number: 2)
      
      proof.liked_by actor
      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: actor, actor: actor,
                                  notifiable: proof, 
                                  action_type: "like")).to be_nil
    end
  end

  describe "liking a comment" do
    context "comment belongs to a problem" do
      let(:problem_comment) {create(:other_comment, user: other_user, commented_on: problem) }

      it "should return the correct feedback" do
        problem_comment.liked_by actor
        feedback = SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:sent]).to eq(1)
      end

      it "should send a notification to the owner of the comment" do
        problem_comment.liked_by actor

        expect(Notification.count).to eq(0)
        SendNotifications.new(notification_type: :upvote, actor: actor,
                          resource: problem_comment).call
        expect(Notification.count).to eq(1)
        expect(Notification.find_by(recipient: other_user, 
                                    actor: actor,
                                    notifiable: problem_comment, 
                                    action_type: "like")).to_not be_nil
      end

      it "should not send a notification to the voter (even if they are the owner)" do
        problem_comment.update(user: actor)
        SendNotifications.new(notification_type: :upvote, actor: actor,
                          resource: problem_comment).call
        expect(Notification.count).to eq(0)
      end

    end

    context "comment belongs to a proof" do
      let(:proof) { create(:proof, user: other_user, problem: problem) }
      let(:proof_comment) { create(:comment, user: other_user, commented_on: proof) }

      it "should return the correct feedback" do
        proof_comment.liked_by actor
        feedback = SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:sent]).to eq(1)
      end

      it "should send a notification to the owner of the comment" do
        proof_comment.liked_by actor

        expect(Notification.count).to eq(0)
        SendNotifications.new(notification_type: :upvote, actor: actor,
                          resource: proof_comment).call
        expect(Notification.count).to eq(1)
        expect(Notification.find_by(recipient: other_user, 
                                    actor: actor,
                                    notifiable: proof_comment, 
                                    action_type: "like")).to_not be_nil

      end

      it "should not send a notification to the voter (even if they are the owner)" do
        proof_comment.update(user: actor)
        SendNotifications.new(notification_type: :upvote, actor: actor,
                          resource: proof_comment).call
        expect(Notification.count).to eq(0)
      end
    end
  end
end
