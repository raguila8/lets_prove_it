class Comment < ApplicationRecord
  before_destroy :update_activities
  after_create :create_activity

  acts_as_votable
  belongs_to :user
  belongs_to :commented_on, polymorphic: true

  has_many :reports, as: :reportable, :dependent => :destroy
  has_many :notifications, as: :notifiable, :dependent => :destroy
  has_many :activities, as: :acted_on, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }
  validate :user_has_privilige

  validates :commented_on_type, presence: true, inclusion: { in: ["Proof", "Problem"] }

  scope :active, -> { where(deleted_on: nil) }


  def get_problem
    commented_on_type == "Proof" ? commented_on.problem : commented_on
  end

  def take_down(deleted_by, deleted_for)
    #action = "took down your comment on"
    #action += (self.commented_on.class.name == "Proof" ? " a proof for" : "")
    #n = Notification.new(actor_id: -1, recipient: self.user, notifiable: self, 
    #                     action_type: "delete", action: action)
    #n.save(validate: false)
    #self.update(deleted_by: "community", deleted_at: Time.now, deleted_for: reason)
    self.soft_delete deleted_by, deleted_for
  end

  def soft_deleted?
    self.deleted_on.nil? ? false : true
  end

  def soft_delete(deleted_by, deleted_for="")
    self.update(deleted_on: Time.now, deleted_by: deleted_by, 
                deleted_for: deleted_for)

    Activity.where(acted_on: self).each do |activity|
      activity.update(deleted_on: Time.now)
    end

    if %w(community proof).include? deleted_by
      action = (self.commented_on_type == "Proof" ? "removed your comment on a proof for " : "removed your comment on")
      n = Notification.new(actor_id: -1, recipient: self.user, action: action, notifiable: self, action_type: "deletion", details: deleted_for)
      n.save(validate: false)
    end
  end


  private

    def create_activity
      linkable = (self.commented_on_type == "Proof" ? self.commented_on.problem : self.commented_on)
        Activity.create(user: self.user, action: "created", acted_on: self, linkable: linkable)
    end

    def user_has_privilige
      if self.user.reputation < 50
        errors.add(:user, 'Needs at least 50 reputation')
      end
    end
end
