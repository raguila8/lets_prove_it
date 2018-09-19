class Comment < ApplicationRecord
  before_destroy :update_activities
  after_create :create_activity

  acts_as_votable
  belongs_to :user
  belongs_to :commented_on, polymorphic: true

  has_many :reports, as: :reportable, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }
  validate :user_has_privilige

  def get_problem
    commented_on_type == "Proof" ? commented_on.problem : commented_on
  end

  def take_down
    action = "took down your comment on"
    action += (self.commented_on.class.name == "Proof" ? " a proof for" : "")
    n = Notification.new(actor_id: -1, recipient: self.user, notifiable: self.get_problem, action: action)
    n.save(validate: false)
    self.update(deleted_by: "community")
    self.destroy
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
