class Comment < ApplicationRecord
  before_destroy :update_activities
  after_create :create_activity

  acts_as_votable
  belongs_to :user
  belongs_to :commented_on, polymorphic: true

  has_many :reports, as: :reportable, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }

  def get_problem
    commented_on_type == "Proof" ? commented_on.problem : commented_on
  end

  private

    def create_activity
      linkable = (self.commented_on_type == "Proof" ? self.commented_on.problem : self.commented_on)
        Activity.create(user: self.user, action: "created", acted_on: self, linkable: linkable)
    end
end
