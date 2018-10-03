require 'rails_helper'

RSpec.describe Notification do
  let(:notification) { build_stubbed(:notification, recipient: other_user, 
                                      actor: user, notifiable: other_user) }
  let(:user) {build_stubbed(:user) }
  let(:other_user) { build_stubbed(:other_user) }

  describe "action_type" do
    it "should not be nil" do
      notification.action_type = nil
      expect(notification.valid?).not_to be_truthy
      notification.action_type = "follow"
      expect(notification.valid?).to be_truthy
    end

    it "should not be empty" do
      notification.action_type = ""
      expect(notification.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      notification.action_type = "a" * 2
      expect(notification.valid?).not_to be_truthy
      notification.action_type = "a" * 3
      expect(notification.valid?).to be_truthy
    end

    it "should have a length of at most 70" do
      notification.action_type = "a" * 70
      expect(notification.valid?).to be_truthy
      notification.action_type = "a" * 71
      expect(notification.valid?).not_to be_truthy
    end
  end

  describe "action" do
    it "should not be nil" do
      notification.action = nil
      expect(notification.valid?).not_to be_truthy
      notification.action = "Started following"
      expect(notification.valid?).to be_truthy
    end

    it "should not be empty" do
      notification.action = ""
      expect(notification.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      notification.action = "a" * 2
      expect(notification.valid?).not_to be_truthy
      notification.action = "a" * 3
      expect(notification.valid?).to be_truthy
    end

    it "should have a length of at most 70" do
      notification.action = "a" * 70
      expect(notification.valid?).to be_truthy
      notification.action = "a" * 71
      expect(notification.valid?).not_to be_truthy
    end
  end

  describe "details" do 
    it "should have a length of at most 500" do
      notification.details = "a" * 500
      expect(notification.valid?).to be_truthy
      notification.details = "a" * 501
      expect(notification.valid?).not_to be_truthy
    end
  end
end
