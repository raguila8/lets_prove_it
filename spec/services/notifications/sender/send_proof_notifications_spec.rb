require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: other_user, topics: [topic]) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }
  before(:each) do
    other_user.follow problem
  end

  describe "New Proofs" do
    let(:new_proof) { create(:proof, problem: problem, user: actor) }

    it "should return the correct feedback" do
      feedback = SendNotifications.new(notification_type: :new_proof,
                                       actor: actor, resource: new_proof).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send a notification to problem followers" do
      second_follower = create(:third_user)
      second_follower.follow problem

      expect(Notification.all.count).to eq(0)
      SendNotifications.new(notification_type: :new_proof,
                                       actor: actor, resource: new_proof).call
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: problem.user, 
                                  actor: actor,
                                  notifiable: new_proof, 
                                  action_type: "new proof")).not_to be_nil
      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: new_proof, 
                                  action_type: "new proof")).not_to be_nil
    end

    it "should send notifications to the creator's followers" do
      follower = create(:third_user)
      follower.follow actor

      # Notification for actor of new follower
      expect(Notification.all.count).to eq(1)
      SendNotifications.new(notification_type: :new_proof,
                                       actor: actor, resource: new_proof).call

      expect(Notification.count).to eq(3)
      expect(Notification.find_by(recipient: follower, 
                                  actor: actor,
                                  notifiable: new_proof, 
                                  action_type: "new proof")).not_to be_nil
    end

    it "should not send you a notification if you are following the problem" do
      actor.follow problem

      expect(Notification.all.count).to eq(0)
      SendNotifications.new(notification_type: :new_proof,
                                       actor: actor, resource: new_proof).call
      
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: actor, 
                                  actor: actor,
                                  notifiable: new_proof, 
                                  action_type: "new proof")).to be_nil
    end
  end

  describe "Updated Proofs" do
    let(:updated_proof) { create(:proof, problem: problem, user: actor) }

    it "should return the correct feedback" do
      feedback = SendNotifications.new(notification_type: :updated_proof,
                                       actor: actor, resource: updated_proof).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end


    it "should send a unique notification to the creator of the problem" do
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: problem.user, 
                                  actor: actor,
                                  notifiable: updated_proof, 
                                  action_type: "proof edit")).not_to be_nil

    end

    it "should send unique notifications to previous editors of the proof" do
      editor = create(:third_user)
      version2 = create(:version, versioned: updated_proof, user: editor, 
                                  version_number: 2)

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call

      # one to the follower and the other to the editor
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: editor, 
                                  actor: actor,
                                  notifiable: updated_proof,
                                  action_type: "proof edit")).not_to be_nil
    end

    it "should send unique notifications to people who have commented on the proof" do
      commenter = create(:third_user, reputation: 500)
      comment = create(:comment, user: commenter, commented_on: updated_proof)

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      # One to creator and the other to the commenter
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: commenter, 
                                  actor: actor,
                                  notifiable: updated_proof,
                                  action_type: "proof edit")).not_to be_nil
    end

    it "should send notifications to users who are following the problem" do
      follower = create(:third_user)
      follower.follow problem

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      # One to creator and the other to the follower
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: follower, 
                                  actor: actor,
                                  notifiable: updated_proof,
                                  action_type: "proof edit")).not_to be_nil

    end

    it "should send notifications to users who are following the updater" do
      follower = create(:third_user)
      follower.follow actor

      # User follow notification
      expect(Notification.count).to eq(1)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      # One to creator and the other to the follower
      expect(Notification.count).to eq(3)
      expect(Notification.find_by(recipient: follower, 
                                  actor: actor,
                                  notifiable: updated_proof,
                                  action_type: "proof edit")).not_to be_nil


    end

    it "should only send one notification to a user, even if user has multiple roles (ie. creator, editor, commenter, follower)" do
      create(:comment, user: other_user, commented_on: updated_proof)
      create(:version, versioned: updated_proof, user: other_user, 
                                  version_number: 2)
      other_user.follow actor

      # User follow notification
      expect(Notification.count).to eq(1)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      # other_user is the creator, a commenter, an editor and a follower but he
      # should only recieve one notification (the creator notification).
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: updated_proof,
                                  action_type: "proof edit")).not_to be_nil

    end

    it "shoud not send a notification to the updater, even if they have multiple roles(ie. creator, editor, commenter, follower)" do
      other_user.unfollow problem
      problem.update(user: actor)
      actor.follow problem
      create(:comment, user: actor, commented_on: updated_proof)
      create(:version, versioned: updated_proof, user: actor, 
                                  version_number: 2)

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_proof, actor: actor,
                            resource: updated_proof).call
      expect(Notification.count).to eq(0)
    end
  end
end
