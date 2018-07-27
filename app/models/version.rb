class Version < ApplicationRecord
  after_create :create_activity
  before_destroy :update_activities

  belongs_to :user
  belongs_to :problem, optional: true
  belongs_to :topic, optional: true
  has_many :version_changes, foreign_key: "version_id", class_name: "Change"
  has_many :change_types, through: :version_changes, :dependent => :destroy
  has_many :version_topics
  has_many :topics, through: :version_topics, dependent: :destroy
  has_many :reports, as: :reportable, :dependent => :destroy
  has_many :reported

  validates :title, presence: true, length: { maximum: 255, minimum: 3 }

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :description, presence: true, length: { maximum: 500, minimum: 3 }
  validate :any_problem_topic?

  def get_version_topics
    it = 1
    while self.topics.empty?
      self.topics = prev_version(it).topics
      it += 1
    end
    return self.topics
  end

  def prev_version(it)
    Version.find_by(problem_id: self.problem_id, version_number: self.version_number - it)
  end

  private

    def create_activity
      action = (self.version_number == 1 ? "created" : "edited")
      Activity.create(user: self.user, action: action, acted_on: self, 
                 linkable: (!self.problem.nil? ? self.problem : self.topic))
    end

    def any_problem_topic?
      if %w(topic_id problem_id).all?{|attr| self[attr].nil?}
        errors.add :base, "Must belong to either a problem or a topic"
      end
    end
end
