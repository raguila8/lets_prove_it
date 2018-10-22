require 'rails_helper'
include Deletion

RSpec.describe Deletion::SoftDelete do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: user, topics: [topic]) }
  let(:deleted_for) { "Just cause..." }
  let(:version) { create(:version, user: user, version_number: 1, 
                         versioned: proof) }
  let!(:proof) { create(:proof, user: user, problem: problem) }
  let(:comment) { create(:comment, user: user, commented_on: proof) }

  it "should soft delete proof" do
    expect(Proof.count).to eq(1)
    expect(proof.deleted_on).to be_nil
    expect(proof.deleted_by).to be_blank
    expect(proof.deleted_for).to be_blank

    SoftDelete.new(resource: proof, deleted_by: :community, 
                   deleted_for: deleted_for).call

    expect(Proof.count).to eq(1)
    expect(proof.deleted_on).to_not be_nil
    expect(proof.deleted_by).to eq('community')
    expect(proof.deleted_for).to eq(deleted_for)
  end

  it "should soft delete all activities with acted_on == proof" do
    activity = Activity.create(user: user, action: "created", acted_on: proof,
                    linkable: problem)
    expect(activity.deleted_on).to be_nil
    expect(Activity.count).to eq(1)

    SoftDelete.new(resource: proof, deleted_by: :community, 
                   deleted_for: deleted_for).call

    expect(Activity.count).to eq(1)
    activity.reload
    expect(activity.deleted_on).to_not be_nil
  end

  it "should soft delete all proof versions" do
    expect(version.deleted_on).to be_nil
    expect(version.deleted_by).to be_blank
    expect(version.deleted_for).to be_blank

    SoftDelete.new(resource: proof, deleted_by: :community, 
                   deleted_for: deleted_for).call

    version.reload
    expect(Version.count).to eq(1)
    expect(version.deleted_on).to_not be_nil
    expect(version.deleted_by).to eq("proof")
    expect(version.deleted_for).to eq("version was deleted as a result of the proof's deletion.")

  end

  it "should soft delete all of the proof's comments" do
    expect(comment.deleted_on).to be_nil
    expect(comment.deleted_for).to be_blank

    SoftDelete.new(resource: proof, deleted_by: :community, 
                   deleted_for: deleted_for).call

    comment.reload
    expect(Comment.count).to eq(1)
    expect(comment.deleted_on).to_not be_nil
    expect(comment.deleted_by).to eq("proof")
    expect(comment.deleted_for).to eq("comment was deleted as a result of the proof's deletion.")
  end

  it "should notify the proof's creator that the proof has been soft deleted" do
    expect(Notification.count).to eq(0)
    SoftDelete.new(resource: proof, deleted_by: :community, 
                   deleted_for: deleted_for).call
    expect(Notification.count).to eq(1)
    expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: proof, 
                                  action_type: "deletion",
                                  details: deleted_for)).not_to be_nil
  end
end
