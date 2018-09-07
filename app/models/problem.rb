class Problem < ApplicationRecord
  before_destroy :update_activities

  include Exceptions
  is_impressionable 
  acts_as_votable

  belongs_to :user
  has_many :user_relationships, class_name: "ProblemFollowing", :dependent => :destroy
  has_many :followers, through: :user_relationships, source: :user
  has_many :versions, -> { order(created_at: :desc) }, :dependent => :destroy
  has_many :proofs, :dependent => :destroy
  has_many :problem_images
  has_many :images, through: :problem_images, :dependent => :destroy
  has_many :problem_topics
  has_many :topics, through: :problem_topics, dependent: :destroy
  has_many :reports, as: :reportable, :dependent => :destroy
  has_many :comments, as: :commented_on, :dependent => :destroy
  validates :topics, length: { minimum: 1 },
                       unless: :new_record?

  validates :cached_proofs_count, presence: true, 
                                    numericality: {only_integer: true,
                                      greater_than_or_equal_to: 0 }


  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :title, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 255, minimum: 3 }


  def save_new(tagsArray, images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        version = Version.create!(problem_id: self.id, version_number: 1, 
                        user_id: user.id, title: self.title, 
                        content: self.content, description: "Problem created")

        #event = Event.create!(args)
        tagsArray.each do |tag|
          topic = Topic.find_by(name: tag)
          if topic and !ProblemTopic.find_by(problem_id: self.id, topic_id: topic.id)
            ProblemTopic.create!(problem_id: self.id, topic_id: topic.id)
            VersionTopic.create!(version_id: version.id, topic_id: topic.id)
          end
        end
        if self.topics.count == 0
          raise Exceptions::ProblemHasNoTopicsError.new, "Problem needs at least one topic."
        end

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ProblemHasNoTopicsError => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def save_edit(tagsArray, images, version_description, user)

    begin
      ActiveRecord::Base.transaction do
        self.save!
        version = Version.create!(problem_id: self.id, 
                      version_number: self.next_version_number, 
                      user_id: user.id, title: self.title,
                      content: self.content, description: version_description)

        #event = Event.create!(args)
        if changed_topics?(tagsArray)
          create_version_topics!(version, tagsArray)
        end

        clear_topics!(tagsArray)
        tagsArray.each do |tag|
          topic = Topic.find_by(name: tag)
          if topic and !ProblemTopic.find_by(problem_id: self.id, topic_id: topic.id)
            ProblemTopic.create!(problem_id: self.id, topic_id: topic.id)
          end
        end

        if self.topics.count == 0
          raise Exceptions::ProblemHasNoTopicsError.new, "Problem needs at least one topic."
        end

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ProblemHasNoTopicsError => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def changed_topics?(tagsArray)
    self.topics.each do |topic|
      if !tagsArray.include?(topic.name)
        return true
      end
    end

    tagsArray.each do |tag|
      if !self.topics.map{|t| t.name}.include?(tag)
        return true
      end
    end

    return false
  end

  def create_version_topics!(version, tagsArray)
    tagsArray.each do |tag|
      topic = Topic.find_by(name: tag)
        if topic
          VersionTopic.create!(version_id: version.id, topic_id: topic.id)
        end
    end
  end

  def clear_topics!(tags)
    topic_delete = true
    self.topics.each do |topic|
      topic_delete = true
      tags.each do |tag|
        if topic.name == tag
          topic_delete = false
        end
      end
      if topic_delete
        ProblemTopic.find_by(problem_id: self.id, topic_id: topic.id).destroy!
      end
    end
  end

  def next_version_number
    versions.order(:created_at).first.version_number + 1
  end

  def self.random_problem
    Problem.order("random()").first.id
  end

  def self.feed(options = {user: nil})
    options[:filter] = "all" if options[:filter].nil?
    options[:sorter] = "updated_at" if options[:sorter].nil?
    if !options[:search_filter].blank?
      self.filter(options[:filter], options[:user]).where("title LIKE :term", term: "%#{options[:search_filter]}%").order("#{options[:sorter]} DESC")
    else
      self.filter(options[:filter], options[:user]).order("#{options[:sorter]} DESC")
    end
  end

  def related_problems
    Problem.joins(:problem_topics).where(problem_topics: { topic_id: topics.pluck(:id)}).order("cached_votes_score DESC").limit(5)
  end

  private

    def self.filter(filter, user)
      equality_symbol = self.equality_symbol(filter)
      problems = ""
      if user
        problems = Problem.joins(topics: :user_relationships).
          where(topic_followings: { user_id: user.id} ).
          union(Problem.joins(:user_relationships).
            where(problem_followings: { user_id: user.id } )).
          where("cached_proofs_count #{equality_symbol} 0").
          distinct
      else
        problems = Problem.all.where("cached_proofs_count #{equality_symbol} 0").
          distinct
      end
 
      return problems
    end

    def self.equality_symbol(filter)
      return ">=" if filter == "all"
      return ">" if filter == "proved"
      return "=" if filter == "not_proved"
    end 
end
