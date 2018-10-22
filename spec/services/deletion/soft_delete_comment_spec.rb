require 'rails_helper'
include Deletion

RSpec.describe Deletion::SoftDelete do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: user, topics: [topic]) }
  let(:deleted_for) { "Just cause..." }
  let!(:proof) { create(:proof, user: user, problem: problem) }

  context "comment belongs to problem" do
    let!(:comment) { create(:comment, user: user, commented_on: problem) }

    it "should soft delete comment" do
      expect(Comment.count).to eq(1)
      expect(comment.deleted_on).to be_nil
      expect(comment.deleted_for).to be_blank

      SoftDelete.new(resource: comment, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Comment.count).to eq(1)
      expect(comment.deleted_on).to_not be_nil
      expect(comment.deleted_for).to eq(deleted_for)
    end

    it "should soft delete all activites with acted_on == comment" do
      expect(Activity.count).to eq(1)
      activity = Activity.find_by(acted_on: comment)
      expect(activity.deleted_on).to be_nil


      SoftDelete.new(resource: comment, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Activity.count).to eq(1)
      activity.reload
      expect(activity.deleted_on).to_not be_nil
    end

    it "should notify the comments creator" do
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: comment, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: comment, 
                                  action_type: "deletion",
                                  details: deleted_for)).not_to be_nil
    end
  end

  context "comment belongs to proof" do
    let!(:comment) { create(:comment, user: user, commented_on: proof) }

    it "should soft delete comment" do
      expect(Comment.count).to eq(1)
      expect(comment.deleted_on).to be_nil
      expect(comment.deleted_for).to be_blank

      SoftDelete.new(resource: comment, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Comment.count).to eq(1)
      expect(comment.deleted_on).to_not be_nil
      expect(comment.deleted_for).to eq(deleted_for)
    end

    it "should soft delete all activites with acted_on == comment" do
      expect(Activity.count).to eq(1)
      activity = Activity.find_by(acted_on: comment)
      expect(activity.deleted_on).to be_nil


      SoftDelete.new(resource: comment, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Activity.count).to eq(1)
      activity.reload
      expect(activity.deleted_on).to_not be_nil
    end

    it "should notify the comment's creator" do
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: comment, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: comment, 
                                  action_type: "deletion",
                                  details: deleted_for)).not_to be_nil
    end
  end
end
