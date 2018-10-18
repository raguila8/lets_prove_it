require 'rails_helper'
include Deletion

RSpec.describe Deletion::SoftDelete do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let!(:problem) { create(:problem, user: user, topics: [topic]) }
  let(:deleted_for) { "Just cause..." }
  let(:version) { create(:version, user: user, version_number: 1, 
                         versioned: problem) }
  let(:proof) { create(:proof, user: user, problem: problem) }
  let(:comment) { create(:comment, user: user, commented_on: problem) }

  it "should soft delete problem" do
    expect(Problem.count).to eq(1)
    expect(problem.deleted_on).to be_nil
    expect(problem.deleted_by).to be_blank
    expect(problem.deleted_for).to be_blank

    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call
    expect(Problem.count).to eq(1)
    expect(problem.deleted_on).to_not be_nil
    expect(problem.deleted_by).to eq('community')
    expect(problem.deleted_for).to eq(deleted_for)
  end

  it "should soft delete all activities with acted_on == problem" do
    activity = Activity.create(user: user, action: "created", acted_on: problem,
                    linkable: problem)
    expect(activity.deleted_on).to be_nil
    expect(Activity.count).to eq(1)

    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call

    expect(Activity.count).to eq(1)
    activity.reload
    expect(activity.deleted_on).to_not be_nil
  end

  it "should soft delete all problem versions" do
    expect(version.deleted_on).to be_nil
    expect(version.deleted_by).to be_blank
    expect(version.deleted_for).to be_blank

    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call

    version.reload
    expect(Version.count).to eq(1)
    expect(version.deleted_on).to_not be_nil
    expect(version.deleted_by).to eq("problem")
    expect(version.deleted_for).to eq("version was deleted as a result of the problem's deletion.")
  end

  it "should soft delete all of the problem's proofs" do
    expect(proof.deleted_on).to be_nil
    expect(proof.deleted_by).to be_blank
    expect(proof.deleted_for).to be_blank

    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call

    proof.reload
    expect(Proof.count).to eq(1)
    expect(proof.deleted_on).to_not be_nil
    expect(proof.deleted_by).to eq("problem")
    expect(proof.deleted_for).to eq("proof was deleted as a result of the problem's deletion.")
  end

  it "should soft delete all of the problem's comments" do
    expect(comment.deleted_on).to be_nil
    expect(comment.deleted_for).to be_blank

    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call

    comment.reload
    expect(Comment.count).to eq(1)
    expect(comment.deleted_on).to_not be_nil
    expect(comment.deleted_by).to eq("problem")
    expect(comment.deleted_for).to eq("comment was deleted as a result of the problem's deletion.")
  end

  it "should notify the problem creator that the problem has been deleted" do
    expect(Notification.count).to eq(0)
    SoftDelete.new(resource: problem, deleted_by: :community, 
                   deleted_for: deleted_for).call
    expect(Notification.count).to eq(1)
    expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: problem, 
                                  action_type: "deletion",
                                  details: deleted_for)).not_to be_nil
  end
  
end

