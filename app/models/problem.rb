class Problem < ApplicationRecord
  include Exceptions
  is_impressionable 
  acts_as_votable

  belongs_to :user
  has_many :versions, :dependent => :destroy
  has_many :proofs, :dependent => :destroy
  has_many :problem_images
  has_many :images, through: :problem_images, :dependent => :destroy
  has_many :problem_topics
  has_many :topics, through: :problem_topics, dependent: :destroy
  validates :topics, length: { minimum: 1 },
                       unless: :new_record?


  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :title, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 255, minimum: 3 }


  def save_with_topics_and_images(tagsArray, images, user)
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

  private
end
