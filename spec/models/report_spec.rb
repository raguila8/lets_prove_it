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

		it "should be valid statuses" do
      valid_statuses = ['pending', 'declined', 'closed', 'in review']
      valid_statuses.each do |valid_status|
			  report.status = valid_status
        expect(report.valid?).to be_truthy, 
          "#{valid_status.inspect} should be valid"
      end
	  end

		it "should not have invalid statuses" do 
      invalid_statuses = ['pendingg', 'open', 'disputed', 'in queue', 
													  'processed']
      invalid_statuses.each do |invalid_status|
			  report.status = invalid_status
        expect(report.valid?).to_not be_truthy, 
          "#{invalid_status.inspect} should be invalid"
      end

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
