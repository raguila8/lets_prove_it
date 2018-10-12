require 'rails_helper'
include Notifications::Remover

RSpec.describe Notifications::Remover::RemoveNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: recipient, topics: [topic]) }
  let(:recipient) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  it "should create a RemoveUpvoteNotifications object when notification_type is :upvote" do
    remover = RemoveNotifications.new(notification_type: :upvote,
                                  actor: actor, resource: problem)
    expect(remover.instance_variable_get(:@notifications_remover)).to be_an_instance_of(RemoveUpvoteNotifications)
  end

end
