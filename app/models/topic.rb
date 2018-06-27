class Topic < ApplicationRecord

  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  before_save { self.name = name.upcase }
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }

  def save_with_images(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Image.add_new_images!("topic", images, user)
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
