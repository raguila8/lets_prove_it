class Topic < ApplicationRecord
  before_destroy :update_activities

  has_many :user_relationships, class_name: "TopicFollowing", :dependent => :destroy
  has_many :followers, through: :user_relationships, source: :user
  has_many :problem_topics
  has_many :problems, through: :problem_topics, dependent: :destroy
  has_many :version_topics
  has_many :versions, :dependent => :destroy
  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  before_save { self.name = name.downcase }
  validates :name, presence: true, length: { minimum: 3, maximum: 35 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :cached_problems_count, presence: true, 
                                    numericality: {only_integer: true,
                                      greater_than_or_equal_to: 0 }
  validates_format_of :name, :with => /^[a-z\d\.\+\-\#]*$/,
    :message => "can only contain a-z, 0-9, +, #, -, ."

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
  def self.feed(options = {sorter: "cached_problems_count"})
    options[:sorter] = "cached_problems_count" if options[:sorter].nil?
    order = "DESC"
    order = "ASC" if options[:sorter] == "name"
    if !options[:search_filter].blank?
      Topic.where("name LIKE ?", "%#{options[:search_filter]}%").
        order("#{options[:sorter]} #{order}")
    else
      Topic.all.order("#{options[:sorter]} #{order}")
    end
  end

  def proofs
    problem_ids = "SELECT problem_id FROM problem_topics
                     WHERE  topic_id = #{id}"
    Proof.where("problem_id IN (#{problem_ids})")
  end

end
