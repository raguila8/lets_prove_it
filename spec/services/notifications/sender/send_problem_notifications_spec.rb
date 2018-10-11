require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: actor, topics: [topic]) }

  describe "New Problem" do
    it "should return the correct feedback" do
      other_user.follow actor
      feedback = SendNotifications.new(notification_type: :new_problem,
                                       actor: actor, resource: problem).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to followers" do
      other_user.follow actor
      second_follower = create(:third_user)
      second_follower.follow actor

      # User follow notifications
      expect(Notification.count).to eq(2)
      SendNotifications.new(notification_type: :new_problem,
                            actor: actor, resource: problem).call
      expect(Notification.count).to eq(4)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "new problem")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "new problem")).not_to be_nil
    end

    it "should not send any notifications to the creator" do
      SendNotifications.new(notification_type: :new_problem,
                            actor: actor, resource: problem).call
      expect(Notification.count).to eq(0)
    end

  end

  describe "Updated Problem" do
    it "should return the correct feedback" do
      other_user.follow problem

      feedback = SendNotifications.new(notification_type: :updated_problem,
                                       actor: actor, resource: problem).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to problem followers" do
      other_user.follow problem
      second_follower = create(:third_user)
      second_follower.follow problem

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_problem,
                                       actor: actor, resource: problem).call
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "problem edit")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "problem edit")).not_to be_nil
    end

    it "should send notifications to editor followers" do
      other_user.follow actor
      second_follower = create(:third_user)
      second_follower.follow actor

      # User follow notifications
      expect(Notification.count).to eq(2)
      SendNotifications.new(notification_type: :updated_problem,
                                       actor: actor, resource: problem).call
      expect(Notification.count).to eq(4)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "problem edit")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "problem edit")).not_to be_nil
    end

    it "should only send users one notification, even if user is both a problem follower and editor follower" do
      other_user.follow actor
      other_user.follow problem

      # User follow notifications
      expect(Notification.count).to eq(1)
      SendNotifications.new(notification_type: :updated_problem,
                                       actor: actor, resource: problem).call
      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: problem, 
                                  action_type: "problem edit")).not_to be_nil
    end

    it "should not send the editor any notifications, even if they folllow the problem" do
      actor.follow problem
      SendNotifications.new(notification_type: :updated_problem,
                            actor: actor, resource: problem).call
      expect(Notification.count).to eq(0)

    end
  end
end
