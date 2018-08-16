class TopicFollowing < ApplicationRecord
  after_create :create_activity
  before_destroy :destroy_activity

  belongs_to :user
  belongs_to :topic

  validates :topic_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: [:topic_id]


  private

    def create_activity
      Activity.create(user: self.user, action: "followed", acted_on: self.topic, linkable: self.topic)
    end

    def destroy_activity
     a = Activity.find_by(user: self.user, action: "followed", acted_on: self.topic, linkable: self.topic)
     a.destroy if !a.nil?
    end


end
