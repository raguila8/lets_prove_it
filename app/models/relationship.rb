class Relationship < ApplicationRecord
  after_create :create_activity
  before_destroy :destroy_activity

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  private

    def create_activity
      Activity.create(user: self.follower, action: "followed", acted_on: self.followed, linkable: self.followed)
    end

    def destroy_activity
      Activity.find_by(user: self.follower, action: "followed", acted_on: self.followed, linkable: self.followed).destroy
    end
end
