class Version < ApplicationRecord
  after_create :create_activity
  before_destroy :update_activities

  belongs_to :user
  belongs_to :versioned, polymorphic: true
  has_many :version_changes, foreign_key: "version_id", class_name: "Change"
  has_many :change_types, through: :version_changes, :dependent => :destroy
  has_many :version_topics
  has_many :topics, through: :version_topics, dependent: :destroy
  has_many :reports, as: :reportable, :dependent => :destroy
  has_many :reported

  has_many :notifications, as: :notifiable, :dependent => :destroy
  has_many :activities, as: :acted_on, :dependent => :destroy


  validates :title, presence: true, length: { maximum: 255, minimum: 3 }

  validates :content, presence: true, length: { maximum: 5000, minimum: 15 }
  validates :description, presence: true, length: { maximum: 750, minimum: 10 }
  validates :version_number, presence: true, numericality: { only_integer: true,
                                               greater_than_or_equal_to: 1 }
  validates_uniqueness_of :version_number, :scope => [:versioned_id, :versioned_type] 
  #validate :any_problem_topic?
  scope :active, -> { where(deleted_on: nil) }

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

  def self.create_problem!(problem, user, tags=nil)
    version = Version.create!(versioned_type: "Problem", 
                    versioned_id: problem.id, 
                    version_number: 1, user_id: user.id,
                    title: problem.title, content: problem.content,
                    description: "Problem created")
    if !tags.nil?
      version.addTopics! tags
    else
      return version
    end
  end

  def addTopics!(tags)
    tags.each do |tag|
      topic = Topic.find_by(name: tag)
      if topic
        VersionTopic.create!(version_id: self.id, topic_id: topic.id)
      end
    end
  end

  def addTopic!(topic)
    VersionTopic.create!(version_id: self.id, topic_id: topic.id)
  end

  def self.next_version_number(versioned)
    if versioned.versions.empty?
      return 1
    else
      return versioned.versions.order(:created_at).first.version_number + 1
    end
  end

  def soft_deleted?
    self.deleted_on.nil? ? false : true
  end

  def soft_delete(deleted_by, deleted_for="")
    self.update(deleted_on: Time.now, deleted_by: deleted_by, deleted_for: deleted_for) 
    Activity.where(acted_on: self).each do |activity|
      activity.update(deleted_on: Time.now)
    end

    if %w(community proof problem).include? deleted_by
      if self.version_number != 1
        action = (self.versioned.class.name == "Proof" ? "removed your edit (version #{self.version_number}) on a proof for " : "removed your edit on")
        n = Notification.new(actor_id: -1, recipient: self.user, action: action, notifiable: self, action_type: "deletion", details: deleted_for)
        n.save(validate: false)
      end
    end

  end


  private

    def create_activity
      action = (self.version_number == 1 ? "created" : "edited")
      Activity.create(user: self.user, action: action, acted_on: self, 
                 linkable: self.versioned)
    end

    def any_problem_topic?
      if %w(topic_id problem_id).all?{|attr| self[attr].nil?}
        errors.add :base, "Must belong to either a problem or a topic"
      end
    end
end
