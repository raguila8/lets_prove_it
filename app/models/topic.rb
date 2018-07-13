class Topic < ApplicationRecord
  has_many :user_relationships, class_name: "TopicFollowing", :dependent => :destroy
  has_many :followers, through: :user_relationships, source: :user
  has_many :problem_topics
  has_many :problems, through: :problem_topics, dependent: :destroy
  has_many :version_topics
  has_many :versions, :dependent => :destroy
  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  before_save { self.name = name.upcase }
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }

  def save_new(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Version.create!(topic_id: self.id, 
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
        Version.create!(topic_id: self.id, 
                      version_number: self.next_version_number, 
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
  def feed
    problem_ids = "SELECT problem_id FROM problem_topics
                     WHERE  topic_id = #{id}"
    Problem.where("id IN (#{problem_ids})")
  end

end
