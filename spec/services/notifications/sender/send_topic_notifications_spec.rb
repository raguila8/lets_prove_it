require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:other_user) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  describe "New Topic" do
    it "should return the correct feedback" do
      other_user.follow actor
      feedback = SendNotifications.new(notification_type: :new_topic,
                                       actor: actor, resource: topic).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to the actor's followers" do
      other_user.follow actor
      second_follower = create(:third_user)
      second_follower.follow actor

      # User follow notifications
      expect(Notification.count).to eq(2)
      SendNotifications.new(notification_type: :new_topic,
                            actor: actor, resource: topic).call

      expect(Notification.count).to eq(4)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: topic, 
                                  action_type: "new topic")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: topic,
                                  action_type: "new topic")).not_to be_nil
    end

    it "should not send any notifications to the creator" do
      SendNotifications.new(notification_type: :new_topic,
                            actor: actor, resource: topic).call
      expect(Notification.count).to eq(0)
    end

  end

  describe "Updated Topic" do
    it "should return the correct feedback" do
      other_user.follow actor
      feedback = SendNotifications.new(notification_type: :updated_topic,
                                       actor: actor, resource: topic).call
      expect(feedback[:response]).to eq(:success)
      expect(feedback[:sent]).to eq(1)
    end

    it "should send notifications to topic followers" do
      other_user.follow topic
      second_follower = create(:third_user)
      second_follower.follow topic

      expect(Notification.count).to eq(0)
      SendNotifications.new(notification_type: :updated_topic,
                            actor: actor, resource: topic).call

      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: topic, 
                                  action_type: "updated topic")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: topic,
                                  action_type: "updated topic")).not_to be_nil
    end

    it "should send notifications to editor's followers" do
      other_user.follow actor
      second_follower = create(:third_user)
      second_follower.follow actor

      # User follow notifications
      expect(Notification.count).to eq(2)
      SendNotifications.new(notification_type: :updated_topic,
                            actor: actor, resource: topic).call

      expect(Notification.count).to eq(4)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: topic, 
                                  action_type: "updated topic")).not_to be_nil

      expect(Notification.find_by(recipient: second_follower, 
                                  actor: actor,
                                  notifiable: topic,
                                  action_type: "updated topic")).not_to be_nil

    end

    it "should only send a user one notification (doesn't matter if they follow both the editor and topic)" do
      other_user.follow actor
      other_user.follow topic

      # User follow notification
      expect(Notification.count).to eq(1)
      SendNotifications.new(notification_type: :updated_topic,
                            actor: actor, resource: topic).call

      expect(Notification.count).to eq(2)
      expect(Notification.find_by(recipient: other_user, 
                                  actor: actor,
                                  notifiable: topic, 
                                  action_type: "updated topic")).not_to be_nil
    end

    it "should not send the editor a notification" do
      actor.follow topic
      SendNotifications.new(notification_type: :updated_topic,
                            actor: actor, resource: topic).call
      expect(Notification.count).to eq(0)
    end
  end
end
