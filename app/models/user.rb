class User < ApplicationRecord
  before_destroy :update_activities
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, UserImageUploader
  acts_as_voter
  acts_as_messageable
  is_impressionable 

  has_many :versions, :dependent => :destroy
  has_many :notifications, foreign_key: :recipient_id, :dependent => :destroy
  has_many :activities, :dependent => :destroy

  has_many :problems_relationships, class_name: "ProblemFollowing", :dependent => :destroy
  has_many :problems_following, through: :problems_relationships, source: :problem
  has_many :topics_relationships, class_name: "TopicFollowing", :dependent => :destroy
  has_many :topics_following, through: :topics_relationships, source: :topic
  has_many :user_topics
  has_many :topics, through: :user_topics, :dependent => :destroy
  has_many :problems
  has_many :proofs, :dependent => :destroy
  has_many :images
  has_many :comments, :dependent => :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :reports, as: :reportable, :dependent => :destroy

  validates :email, presence: true, length: { maximum: 255 },
										uniqueness: { case_sensitive: false }
  validates :bio, length: { maximum: 500 }
  validates :name, length: { maximum: 70 }
  validates :occupation, length: { maximum: 70 }
  validates :education, length: { maximum: 70 }
  validates :location, length: { maximum: 70 }
  validates :reputation, presence: true, numericality: { only_integer: true }


  validates :username, presence: true, length: { minimum: 5, maximum: 18 },
											uniqueness: true
  validate :avatar_size

  def following?(model)
    if model.class.name == "Problem"
      self.problems_following.include?(model)
      #ProblemFollowing.exists?(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      self.topics_following.include?(model)
      #TopicFollowing.exists?(user_id: self.id, topic_id: model.id)
    elsif model.class.name == "User"
      self.following.include?(model)
    end
  end

  def follow(model)
    if model.class.name == "Problem"
      self.problems_following << model
      #ProblemFollowing.create(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      self.topics_following << model
      #TopicFollowing.create(user_id: self.id, topic_id: model.id)
    elsif model.class.name == "User"
      self.following << model
    end
  end

  def unfollow(model)
    if model.class.name == "Problem"
      self.problems_following.destroy(model)
      #ProblemFollowing.find_by(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "Topic"
      self.topics_following.destroy(model)
      #ProblemFollowing.find_by(user_id: self.id, problem_id: model.id)
    elsif model.class.name == "User"
      self.following.destroy(model)
    end
  end

  def problem_feed
    Problem.joins(topics: :user_relationships).
      where(topic_followings: { user_id: id} ).
      union(Problem.joins(:user_relationships).
        where(problem_followings: { user_id: id } )).
      distinct.order(created_at: :desc)
  end

  def unread_messages
    self.mailbox.conversations.unread(self)
  end
 
  def unread_notifications
    Notification.where(recipient: self).unread
  end

  def notifications
    Notification.where(recipient: self)
  end

  def self.search(pattern)
    users = User.select("username AS label", "id AS id", "'Users' AS category", "CASE avatar WHEN '' THEN '/assets/avatar.png' ELSE avatar END AS image_url").where("username LIKE ?", pattern).limit(5)

    topics = Topic.select("name AS label", "id AS id", "'Topics' AS category").where("name LIKE ?", pattern).limit(5)

    problems = Problem.select("title AS label", "id AS id", "'Problems' AS category", "'/assets/no_problems_icon.png' AS image_url").where("title LIKE ?", pattern).limit(5)
      
    users + topics + problems
  end

  def subinfo
    return name if name
    return location if location
    return occupation if occupation
    return education if education
    return "<strong style='margin-right: 5px;'>Member Since: </strong> #{created_at.strftime('%B %d, %Y')}"
  end

  def self.feed(options = {user: ""})
    options[:filter] = "all" if options[:filter].nil?
    options[:sorter] = "reputation" if options[:sorter].nil?
    order = "DESC"
    order = "ASC" if options[:sorter] == "username"
    if !options[:search_filter].blank?
      self.filter(options[:filter], options[:user]).
        where("name LIKE :term OR username LIKE :term", 
          term: "%#{options[:search_filter]}%").
        order("#{options[:sorter]} #{order}")
    else
      self.filter(options[:filter], options[:user]).
        order("#{options[:sorter]} #{order}")
    end
  end

  def vote(vote_type, model)
    action_taken = ""
    if vote_type == "like"
      if self.voted_down_on? model
        model.undisliked_by self
        action_taken = "undisliked"
      elsif !self.liked? model
        model.liked_by self
        Notification.notify_user_of_vote(self, model)
        action_taken = "liked"
      end
    else
      if self.liked? model
        model.unliked_by self
        Notification.remove_vote_notification(self, model)
        action_taken = "unliked"
      elsif !self.voted_down_on? model
        model.downvote_from self
        action_taken = "downvoted"
      end
    end
  
    User.update_reputation({action: action_taken, actor: self, voted_on: model})
    return action_taken
  end

  def self.update_reputation(options = {})
    if %w(liked unliked undisliked downvoted).include? options[:action]
      User.update_reputation_after_vote action: options[:action], 
                                        actor: options[:actor], 
                                        voted_on: options[:voted_on]
    else

    end
  end
  
  private

    def self.update_reputation_after_vote(action, actor, voted_on)
      recipient = voted_on.user

	    if action == "liked"
        if voted_on.class.name == "Problem"
          recipient.update(reputation: recipient.reputation += 5)
        elsif voted_on.class.name == "Proof"
          recipient.update(reputation: recipient.reputation += 10)
        elsif voted_on.class.name == "Comment"
          recipient.update(reputation: recipient.reputation += 2)
        end
      elsif action == "unliked"
        if voted_on.class.name == "Problem"
          recipient.update(reputation: recipient.reputation -= 5)
        elsif voted_on.class.name == "Proof"
          recipient.update(reputation: recipient.reputation -= 10)
        elsif voted_on.class.name == "Comment"
          recipient.update(reputation: recipient.reputation -= 2)
        end
      elsif action == "undisliked"
        if voted_on.class.name == "Problem"
          recipient.update(reputation: recipient.reputation += 2)
        elsif voted_on.class.name == "Proof"
          recipient.update(reputation: recipient.reputation += 2)
        elsif voted_on.class.name == "Comment"
          recipient.update(reputation: recipient.reputation += 1)
        end
        actor.update(reputation: actor.reputation += 1)
      elsif action == "downvoted"
        if voted_on.class.name == "Problem"
          recipient.update(reputation: recipient.reputation -= 2)
        elsif voted_on.class.name == "Proof"
          recipient.update(reputation: recipient.reputation -= 2)
        elsif voted_on.class.name == "Comment"
          recipient.update(reputation: recipient.reputation -= 1)
        end
        actor.update(reputation: actor.reputation -= 1)
      end
    end

		# Validates the size of an uploaded image
		def avatar_size
			if self.avatar.size > 5.megabytes
				errors.add(:avatar, "should be less than 5MB")
			end
		end

    def self.filter(filter, user)
      if user.blank? or filter == "all"
        User.all
      elsif filter == "following"
        user.following
      elsif filter == "followers"
        user.followers
      end
    end

end
