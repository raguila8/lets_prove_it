class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, UserImageUploader
  acts_as_voter

  has_many :problems_following, class_name: "ProblemFollowing", :dependent => :destroy
  has_many :topics_following, class_name: "TopicFollowing", :dependent => :destroy
  has_many :user_topics
  has_many :topics, through: :user_topics, :dependent => :destroy
  has_many :problems
  has_many :proofs, :dependent => :destroy
  has_many :images
  has_many :comments, :dependent => :destroy

  validates :email, presence: true, length: { maximum: 255 },
										uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 70 }
  validates :username, presence: true, length: { minimum: 5, maximum: 18 },
											uniqueness: true
  validate :avatar_size

  def following?(model)
    if model.class.name == "Problem"
      ProblemFollowing.exists?(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      TopicFollowing.exists?(user_id: self.id, topic_id: model.id)
    elsif model.class.name == "User"
      self.following.include?(model)
    end
  end

  def follow(model)
    if model.class.name == "Problem"
      ProblemFollowing.create(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      TopicFollowing.create(user_id: self.id, topic_id: model.id)
    elsif model.class.name == "User"
      self.following << model
    end
  end

  def unfollow(model)
    if model.class.name == "Problem"
      ProblemFollowing.find_by(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      ProblemFollowing.find_by(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "User"
      self.following.delete(model)
    end
  end

  def problem_feed
=begin
    topic_ids = "SELECT topic_id FROM topic_followings
                 WHERE user_id = #{id}"
    problem_ids = "SELECT problem_id FROM problem_topics
                     WHERE  topic_id IN (#{topic_ids})"
=end
    Problem.joins("inner join problem_topics as pt on problems.id = pt.problem_id").
            joins("inner join topic_followings as tf on pt.topic_id = tf.topic_id").order(:created_at).distinct
    #Problem.where("id IN (#{problem_ids})").order(:created_at)
  end

  
  private
	
		# Validates the size of an uploaded image
		def avatar_size
			if self.avatar.size > 5.megabytes
				errors.add(:avatar, "should be less than 5MB")
			end
		end

end
