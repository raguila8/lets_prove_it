require 'rails_helper'
include Deletion

RSpec.describe Deletion::SoftDelete do
  let(:user) { create(:user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:problem) { create(:problem, user: user, topics: [topic]) }
  let(:deleted_for) { "Just cause..." }
  let(:proof) { create(:proof, user: user, problem: problem) }
  let(:comment) { create(:comment, user: user, commented_on: proof) }

  context "version belongs to problem" do
    let!(:version) { create(:version, user: user, version_number: 1, 
                         versioned: problem) }
    
    it "should soft delete version" do
      expect(Version.count).to eq(1)
      expect(version.deleted_on).to be_nil
      expect(version.deleted_by).to be_blank
      expect(version.deleted_for).to be_blank

      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call

      expect(Version.count).to eq(1)
      expect(version.deleted_on).to_not be_nil
      expect(version.deleted_by).to eq('community')
      expect(version.deleted_for).to eq(deleted_for)
    end

    it "should delete all activities with acted_on == version" do
      expect(Activity.count).to eq(1)
      activity = Activity.find_by(acted_on: version)
      expect(activity.deleted_on).to be_nil


      SoftDelete.new(resource: version, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Activity.count).to eq(1)
      activity.reload
      expect(activity.deleted_on).to_not be_nil
    end

    it "should not notify the version's creator when version_number is 1" do
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(0)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to be_nil
    end

    it "should notify the version's creator when version_number is not 1" do
      version.update(version_number: 2)
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to_not be_nil
    end

  end

  context "version belongs to proof" do
    let!(:version) { create(:version, user: user, version_number: 1, 
                         versioned: proof) }

    it "should soft delete version" do
      expect(Version.count).to eq(1)
      expect(version.deleted_on).to be_nil
      expect(version.deleted_by).to be_blank
      expect(version.deleted_for).to be_blank

      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call

      expect(Version.count).to eq(1)
      expect(version.deleted_on).to_not be_nil
      expect(version.deleted_by).to eq('community')
      expect(version.deleted_for).to eq(deleted_for)
    end

    it "should delete all activities with acted_on == version" do
      expect(Activity.count).to eq(1)
      activity = Activity.find_by(acted_on: version)
      expect(activity.deleted_on).to be_nil


      SoftDelete.new(resource: version, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Activity.count).to eq(1)
      activity.reload
      expect(activity.deleted_on).to_not be_nil
    end

    it "should not notify the version's creator when version_number is 1" do
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(0)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to be_nil
    end

    it "should notify the version's creator when version_number is not 1" do
      version.update(version_number: 2)
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to_not be_nil
    end
  end

  context "version belongs to topic" do
    let!(:version) { create(:version, user: user, version_number: 1, 
                             versioned: topic) }

    it "should soft delete version" do
      expect(Version.count).to eq(1)
      expect(version.deleted_on).to be_nil
      expect(version.deleted_by).to be_blank
      expect(version.deleted_for).to be_blank

      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call

      expect(Version.count).to eq(1)
      expect(version.deleted_on).to_not be_nil
      expect(version.deleted_by).to eq('community')
      expect(version.deleted_for).to eq(deleted_for)
    end

    it "should delete all activities with acted_on == version" do
      expect(Activity.count).to eq(1)
      activity = Activity.find_by(acted_on: version)
      expect(activity.deleted_on).to be_nil


      SoftDelete.new(resource: version, deleted_by: :community, 
                   deleted_for: deleted_for).call

      expect(Activity.count).to eq(1)
      activity.reload
      expect(activity.deleted_on).to_not be_nil
    end

    it "should not notify the version's creator when version_number is 1" do
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(0)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to be_nil
    end

    it "should notify the version's creator when version_number is not 1" do
      version.update(version_number: 2)
      expect(Notification.count).to eq(0)
      SoftDelete.new(resource: version, deleted_by: :community, 
                     deleted_for: deleted_for).call
      expect(Notification.count).to eq(1)
      expect(Notification.find_by(recipient: user, 
                                  actor_id: -1,
                                  notifiable: version, 
                                  action_type: "deletion",
                                  details: deleted_for)).to_not be_nil
    end
  end
end

