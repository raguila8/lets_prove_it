class BookmarkedProblem < ApplicationRecord
  after_create :create_activity
  before_destroy :destroy_activity

  belongs_to :user
  belongs_to :problem

  validates :problem_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: [:problem_id]


  private

    def create_activity
      Activity.create(user: self.user, action: "bookmarked", acted_on: self.problem, linkable: self.problem)
    end

    def destroy_activity
      Activity.find_by(user: self.user, action: "bookmarked", acted_on: self.problem, linkable: self.problem).destroy
    end
end
