require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: recipient, topics: [topic]) }
  let(:recipient) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  it "should create a SendUpvoteNotifications object when notification_type is :upvote_notification" do
    sender = SendNotifications.new(notification_type: :upvote,
                                  actor: actor, resource: problem)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendUpvoteNotifications)
  end

  it "should create a SendCommentNotifications object when notification_type is :comment_notification" do
    comment = create(:comment, commented_on: problem, user: actor)
    sender = SendNotifications.new(notification_type: :new_comment,
                                  resource: comment)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendCommentNotifications)
  end
end

