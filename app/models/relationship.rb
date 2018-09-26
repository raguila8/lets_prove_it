class Relationship < ApplicationRecord
  after_create :create_activity
  before_destroy :destroy_activity

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validates_uniqueness_of :follower_id, scope: [:followed_id]


  private

    def create_activity
      Activity.create(user: self.follower, action: "followed", acted_on: self.followed, linkable: self.followed)
      Notification.create(recipient: followed, actor: follower, notifiable: follower, action: "started following", action_type: "follow")
    end

    def destroy_activity
      a = Activity.find_by(user: self.follower, action: "followed", acted_on: self.followed, linkable: self.followed)
      a.destroy if !a.nil?
      n = Notification.find_by(recipient: followed, actor: follower, 
                               notifiable: follower, 
                               action: "started following", 
                               action_type: "follow")
      n.destroy if !n.nil?

    end
end
