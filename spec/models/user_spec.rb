require 'rails_helper'

RSpec.describe User do
  let (:user) { build_stubbed(:user) }

  describe "username" do
    it "should not be nil" do
      user.username = nil
      expect(user.valid?).not_to be_truthy
      user.username = "rodrigo"
      expect(user.valid?).to be_truthy
    end 
  end
end
