require 'rails_helper'

RSpec.describe Report do
  let(:report) { build_stubbed(:report, user: user, reportable: problem) }
  let(:problem) { build_stubbed(:problem, user: other_user) }
  let(:user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:other_user) }

  it "should only have one active report per user and reportable pair" do
    saved_report = create(:report, user: user, reportable: problem, expired_on: nil)
    expect(report.valid?).not_to be_truthy
    saved_report.update(expired_on: Time.now)
    expect(report.valid?).to be_truthy
  end

  describe "status" do
    it "should not be nil" do
      report.status = nil
      expect(report.valid?).not_to be_truthy
      report.status = "pending"
      expect(report.valid?).to be_truthy
    end

    it "should not be empty" do
      report.status = ""
      expect(report.valid?).not_to be_truthy
    end

    it "should have a length of at least 3" do
      report.status = "a" * 2
      expect(report.valid?).not_to be_truthy
      report.status = "a" * 3
      expect(report.valid?).to be_truthy
    end

    it "should have a length of at most 70" do
      report.status = "a" * 70
      expect(report.valid?).to be_truthy
      report.status = "a" * 71
      expect(report.valid?).not_to be_truthy
    end
  end

  describe "details" do
    it "should have a length of at most 2500" do
      report.details = "a" * 2500
      expect(report.valid?).to be_truthy
      report.details = "a" * 2501
      expect(report.valid?).not_to be_truthy
    end
  end

  describe "reason" do
    it "should have a length of at most 500" do
      report.reason = "a" * 500
      expect(report.valid?).to be_truthy
      report.reason = "a" * 501
      expect(report.valid?).not_to be_truthy
    end
  end 
end
