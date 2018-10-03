require 'rails_helper'

RSpec.describe Activity do
  let(:activity) { build_stubbed(:activity, user: user, acted_on: topic, 
                                 linkable: topic) }
  let(:user) { build_stubbed(:user) }
  let(:topic) { build_stubbed(:topic) }

  describe "action" do
    it "should not be nil" do
      activity.action = nil
      expect(activity.valid?).not_to be_truthy
      activity.action = "Created"
      expect(activity.valid?).to be_truthy
    end

    it "should not be empty" do
      activity.action = ""
      expect(activity.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      activity.action = "a" * 2
      expect(activity.valid?).not_to be_truthy
      activity.action = "a" * 3
      expect(activity.valid?).to be_truthy
    end

    it "should have a length of at most 70" do
      activity.action = "a" * 70
      expect(activity.valid?).to be_truthy
      activity.action = "a" * 71
      expect(activity.valid?).not_to be_truthy
    end
  end
end
