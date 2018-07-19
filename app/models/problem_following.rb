class ProblemFollowing < ApplicationRecord
  after_create :create_activity
  before_destroy :destroy_activity

  belongs_to :user
  belongs_to :problem

  validates :problem_id, presence: true
  validates :user_id, presence: true

  private

    def create_activity
      Activity.create(user: self.user, action: "followed", acted_on: self.problem, linkable: self.problem)
    end

    def destroy_activity
      Activity.find_by(user: self.user, action: "followed", acted_on: self.problem, linkable: self.problem).destroy
    end
end
