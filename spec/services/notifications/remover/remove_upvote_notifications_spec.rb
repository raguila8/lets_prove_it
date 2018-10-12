require 'rails_helper'
include Notifications::Remover

RSpec.describe Notifications::Remover::RemoveNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  describe "unliking a problem" do
    before(:each) do
      create(:version, versioned: problem, 
                                   user: other_user, version_number: 1)
    end

    it "should return the correct feedback" do
      problem.liked_by actor
      Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem).call
      feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: problem).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:removed]).to eq(1)
    end

    it "should remove the notifications sent to all previous editors" do
      other_editor = create(:third_user)
      create(:other_version, versioned: problem,
                                   user: other_editor, version_number: 2)

      problem.liked_by actor
      Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem).call
      # Two editors
      expect(Notification.count).to eq(2)
      feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: problem).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:removed]).to eq(2)

      expect(Notification.count).to eq(0)
    end
  end

  describe "unliking a proof" do
    let(:proof) { create(:proof, user: other_user, problem: problem) }
    before(:each) do
      create(:version, versioned: proof, 
                                   user: other_user, version_number: 1)
    end

    it "should return the correct feedback" do
      proof.liked_by actor

      Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof).call
      feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: proof).call

      expect(feedback[:response]).to eq(:success)
      expect(feedback[:removed]).to eq(1)
    end

    it "should remove sent notifications to editors" do
      other_editor = create(:third_user)
      create(:other_version, versioned: proof,
                                   user: other_editor, version_number: 2)

      proof.liked_by actor
      Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof).call
      # Two editors
      expect(Notification.count).to eq(2)
      feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: proof).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:removed]).to eq(2)

      expect(Notification.count).to eq(0)
    end
  end

  describe "unliking a comment" do
    context "comment belongs to a problem" do
      let(:problem_comment) {create(:other_comment, user: other_user, commented_on: problem) }

      it "should return the correct feedback" do
        problem_comment.liked_by actor

        Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem_comment).call
        feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: problem_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:removed]).to eq(1)
      end

      it "should remove the notification sent to owner" do
        problem_comment.liked_by actor

        Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: problem_comment).call

        expect(Notification.count).to eq(1)
        feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: problem_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:removed]).to eq(1)

        expect(Notification.count).to eq(0)
      end
    end

    context "comment belongs to a proof" do
      let(:proof) { create(:proof, user: other_user, problem: problem) }
      let(:proof_comment) { create(:comment, user: other_user, commented_on: proof) }

      it "should return the correct feedback" do
        proof_comment.liked_by actor

        Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof_comment).call
        feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: proof_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:removed]).to eq(1)
      end

      it "should remove the notification sent to the owner" do
        proof_comment.liked_by actor

        Notifications::Sender::SendNotifications.new(notification_type: :upvote, 
                                       actor: actor, resource: proof_comment).call

        expect(Notification.count).to eq(1)
        feedback = RemoveNotifications.new(notification_type: :upvote, 
                                         actor: actor,
                                         resource: proof_comment).call
        expect(feedback[:response]).to eq(:success)
        expect(feedback[:removed]).to eq(1)

        expect(Notification.count).to eq(0)
      end
    end
  end
end
