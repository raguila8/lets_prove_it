class Comment < ApplicationRecord
  before_destroy :update_activities
  after_create :create_activity

  acts_as_votable
  belongs_to :user
  belongs_to :proof

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }

  private

    def create_activity
      Activity.create(user: self.user, action: "created", acted_on: self, linkable: self.proof.problem)
    end
end
