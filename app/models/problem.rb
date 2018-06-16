class Problem < ApplicationRecord
  include Exceptions
  belongs_to :user
  has_many :proofs, :dependent => :destroy
  has_many :problem_images, :dependent => :destroy
  has_many :problem_topics
  has_many :topics, through: :problem_topics, :dependent => :destroy
  validates :topics, length: { minimum: 1 },
                       unless: :new_record?


  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :title, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 255, minimum: 3 }


  def save_with_topics(tagsArray)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        #event = Event.create!(args)
        tagsArray.each do |tag|
          topic = Topic.find_by(name: tag)
          if topic
            ProblemTopic.create!(problem_id: self.id, topic_id: topic.id)
          end
        end
        if self.topics.count == 0
          raise Exceptions::ProblemHasNoTopicsError.new, "Problem needs at least one topic."
        end
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ProblemHasNoTopicsError => exception
      return { exception: exception }
    end
    return { }
  end
end
