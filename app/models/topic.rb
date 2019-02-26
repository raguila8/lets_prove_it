class Topic < ApplicationRecord
  before_destroy :update_activities

  has_many :user_relationships, class_name: "TopicFollowing", :dependent => :destroy
  has_many :followers, through: :user_relationships, source: :user
  has_many :problem_topics
  has_many :problems, through: :problem_topics, dependent: :destroy
  has_many :version_topics
  has_many :versions, -> { order(created_at: :desc) }, 
             as: :versioned, dependent: :destroy
  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  has_many :notifications, as: :notifiable, :dependent => :destroy
  has_many :activities, as: :acted_on, :dependent => :destroy


  before_save { self.name = name.downcase.titleize }
  validates :name, presence: true, length: { minimum: 3, maximum: 25 },
                   uniqueness: true
  validates :description, length: { maximum: 10000 }
  validates :cached_problems_count, presence: true, 
                                    numericality: {only_integer: true,
                                      greater_than_or_equal_to: 0 }

  validates_format_of :name, :with => /\A[A-Za-z\d\s]*\z/,
    :message => "can only contain a-z, A-Z, 0-9, ' '"

  scope :active, -> { where(deleted_on: nil) }

  def save_new(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Version.create!(versioned: self, 
                      version_number: 1, 
                      user_id: user.id, title: self.name,
                      content: self.description, description: "Topic Created")

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def save_edit(images, version_description, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Version.create!(versioned: self, 
                      version_number: Version.next_version_number(self),          #self.next_version_number
                      user_id: user.id, title: self.name,
                      content: self.description, description: version_description)

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def next_version_number
    versions.order(:created_at).last.version_number + 1
  end


  # Returns a topic's problem feed.
  def self.feed(options = {sorter: "cached_problems_count"})
    options[:sorter] = "cached_problems_count" if options[:sorter].nil?
    order = "DESC"
    order = "ASC" if options[:sorter] == "name"
    if !options[:search_filter].blank?
      Topic.where("name LIKE ?", "%#{options[:search_filter]}%").active.
        order("#{options[:sorter]} #{order}")
    else
      Topic.all.active.order("#{options[:sorter]} #{order}")
    end
  end

  def proofs
    problem_ids = "SELECT problem_id FROM problem_topics
                     WHERE  topic_id = #{id}"
    Proof.where("problem_id IN (#{problem_ids})")
  end

  def soft_deleted?
    self.deleted_on.nil? ? false : true
  end

  def trending_problem 
    n = 1
    problems = self.problems.where('problems.created_at >= ?', n.week.ago)
    while problems.count == 0
      n += 1
      problems = self.problems.where('problems.created_at >= ?', n.week.ago)
    end

    problems.where(cached_votes_score: problems.maximum('cached_votes_score')).first
  end

  def featured_problem
    @featured_problem ||= trending_problem
  end

  def related_topics
    Topic.select("topics.id, topics.name, count(problem_topics.topic_id) as count").where.not(id: self.id).joins(:problem_topics).where(problem_topics: { problem_id: problems }).group("problem_topics.topic_id").order("count DESC").limit(5)
  end

  def self.search(pattern)
    Topic.select("name AS label", "id AS id", "cached_problems_count AS cached_problems_count").where("name LIKE ?", pattern).limit(5)

  end

  private

    
end
