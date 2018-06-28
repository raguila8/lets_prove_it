class Topic < ApplicationRecord
  has_many :problem_topics
  has_many :problems, through: :problem_topics, dependent: :destroy
  has_many :version_topics
  has_many :versions, through: :versions, :dependent => :destroy
  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  before_save { self.name = name.upcase }
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }

  def save_with_images(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  # Returns a topic's problem feed.
  def feed
    problem_ids = "SELECT problem_id FROM problem_topics
                     WHERE  topic_id = #{id}"
    Problem.where("id IN (#{problem_ids})")
  end

end
