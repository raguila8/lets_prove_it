class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  validates :action_type, presence: true
  validates :details, length: { maximum: 5000 }

  scope :unread, ->{ where(read_at: nil) }
  scope :active, ->{ where(notifiable: { deleted_on: nil }) }

  def is_read?
    !self.read_at.nil?
  end

  def linkable?
    not self.linked_to.nil? and not self.linked_to.soft_deleted?
  end

  def linked_to
    if self.notifiable_type == "Problem"
      return self.notifiable
    elsif self.notifiable_type == "User"
      return self.notifiable
    elsif self.notifiable_type == "Topic"
      return self.notifiable
    elsif self.notifiable_type == "Comment"
      return self.notifiable.get_problem
    elsif self.notifiable_type == "Proof"
      return self.notifiable.problem
    elsif self.notifiable_type == "Version"
      return self.notifiable.versioned if %w(Topic Problem).include? self.notifiable.versioned.class.name
      return self.notifiable.versioned.problem if self.notifiable.versioned.class.name == "Proof"
    end
  end

  def link
    "/#{self.linked_to.class.name.downcase.pluralize}/#{self.linked_to.id}"
  end

  def message
    message = self.action
    if self.notifiable_type == "Problem"
      message += " problem <i style='text-transform: none;'>#{self.notifiable.title.titleize}</i>"
    elsif self.notifiable_type == "User"
      message += " you"
    elsif self.notifiable_type == "Topic"
      message += " topic <i style='text-transform: none;'>#{self.notifiable.name.titleize}</i>".html_safe
    elsif self.notifiable_type == "Comment"
      message += " problem <i style='text-transform: none;'>#{self.notifiable.get_problem.title.titleize}</i>"
    elsif self.notifiable_type == "Proof"
      message += " problem <i style='text-transform: none;'>#{self.notifiable.problem.title.titleize}</i>"
    elsif self.notifiable_type == "Version"
      if %w(Proof Problem).include? self.notifiable.versioned.class.name
        message += " problem <i style='text-transform: none;'>#{self.notifiable.problem.title.titleize}</i>"
      else
        message += " topic <i style='text-transform: none;'>#{self.notifiable.name.titleize}</i>".html_safe
      end
    end
    message.html_safe
  end

  def self.notify_user(recipient, actor, action, notifiable, action_type, details="")
    Notification.create(recipient: recipient, actor: actor, action: action, 
                        notifiable: notifiable, action_type: action_type, 
                        details: details)
  end

  def self.notify_user_of_vote(actor, voted_on)
    action_type = "like"
    if voted_on.class.name == "Problem"
      # Notify problem editors that the problem has been liked/disliked
      ((voted_on.versions.map{ |version| version.user }).uniq - [actor]).each do |editor|
        Notification.notify_user(editor, actor, "liked", voted_on, action_type) if editor != actor
      end
    elsif voted_on.class.name == "Comment"
      # Notify owner of comment
      action = (voted_on.commented_on_type == "Proof" ? "liked your comment on a proof for" : "liked your commnent on")
      
      Notification.notify_user(voted_on.user, actor, action, voted_on, action_type) if voted_on.user != actor
    elsif voted_on.class.name == "Proof"
      # Notify owner of proof
      Notification.notify_user(voted_on.user, actor, "liked your proof for", voted_on, action_type) if voted_on.user != actor
    end
  end

  def self.new_comment_notifications(comment)
    notifiable = comment.commented_on
    action_type = "comment"
    # Notify people who have commented on the post
    ((comment.commented_on.comments.map{ |c| c.user }).uniq - [comment.user, comment.commented_on.user]).each do |commenter|
      action = (comment.commented_on_type == "Proof" ? "commented on a proof you have commented on for" : "commented on")
      Notification.notify_user(commenter, comment.user, action, notifiable, action_type) 
    end

    # Notify the person who wrote the post
    action = (comment.commented_on_type == "Proof" ? "commented on your proof for" : "commented on")
    Notification.notify_user(comment.commented_on.user, comment.user, action, notifiable, action_type) if comment.commented_on.user != comment.user
  end

  def self.remove_vote_notification(actor, voted_on)
    if voted_on.class.name == "Problem"
      # Remove notifications from problem editors
      ((voted_on.versions.map{ |version| version.user }).uniq - [actor]).each do |editor|
        n = Notification.find_by(recipient: editor,
                                 actor: actor,
                                 notifiable: voted_on,
                                 action_type: "like") if editor != actor
        n.destroy if !n.nil?
      end
    elsif voted_on.class.name == "Comment"
      # Remove notification from owner of comment 
      n = Notification.find_by(recipient: voted_on.user, actor: actor, 
                action_type: "like",
                notifiable: voted_on) if voted_on.user != actor
      n.destroy if !n.nil?
    elsif voted_on.class.name == "Proof"
      # Remove notifications from  owner of proof
      n = Notification.find_by(recipient: voted_on.user, actor: actor, 
                action_type: "like", 
                notifiable: voted_on) if voted_on.user != actor
      n.destroy if !n.nil?
    end
  end

  def self.new_problem_notifications(problem)
    # Notify users that follow @problem.topics
=begin
    @problem.topics.each do |topic|
      (topic.followers - [current_user]).each do |follower|
        Notification.notify_user(follower, current_user, "created", @problem)
      end
    end
=end
  end

  def self.updated_problem_notifications(problem, editor=nil)
    if editor.nil?
      editor = problem.versions.last.user
    end

    action = "edited"
    notifiable = problem
    action_type = "edit"

    (problem.followers  - [editor]).each do |follower|
      Notification.notify_user(follower, editor, action, notifiable, action_type) 
    end
  end

  def self.feed(options = { user: nil })
    options[:filter] = "all" if options[:filter].nil?
    options[:sorter] = "created_at" if options[:sorter].nil?
    self.filter(options[:filter], options[:user]).order("#{options[:sorter]} DESC")
  end

  # Send notifications to users who follow a problem when a new proof is 
  # created
  def self.new_proof_notifications(proof)
    action = "posted a new proof for"
    action_type = "proof"
    notifiable = proof
    (proof.problem.followers - [proof.user]).each do |follower|
      Notification.notify_user(follower, proof.user, action,
                               notifiable, action_type) 
    end
  end

  def self.updated_proof_notifications(proof, editor=nil)
    action1 = "edited a proof you have previously edited for"
    action2 = "edited a proof that you have commented on for"
    action3 = "edited a proof for"
    action4 = "edited your proof for"
    action_type = "edit"
    notifiable = proof
    if editor.nil?
      editor = proof.versions.last.user
    end

    # Notify creator of proof if editor is not creator
    if proof.user != editor
      Notification.notify_user(proof.user, editor, action4,
                               notifiable, action_type)
    end

    # Send notifications to users who have previously edited the proof
    editors = ((proof.versions.map { |v| v.user }).uniq)
    (editors - [editor, proof.user].uniq).each do |e|
      Notification.notify_user(e, editor, action1,
                               notifiable, action_type) 
    end

    # Send notifications to users who have commented on the proof
    commenters = (proof.comments.map { |c| c.user }).uniq 
    (commenters - (editors + [editor, proof.user].uniq)).each do |commenter|
      Notification.notify_user(commenter, editor, action2,
                               notifiable, action_type) 
    end

    # Send notifications to users who follow the proof's problem
    exclusions = (commenters + editors + [editor, proof.user].uniq)
    (proof.problem.followers - exclusions).each do |follower|
      Notification.notify_user(follower, editor, action3,
                               notifiable, action_type) 
    end
  end

  def self.new_topic_notifications(topic)
    #Notify all users when a topic is created
=begin
    (User.all - [current_user]).each do |user|
      Notification.notify_user(user, current_user, "created", @topic)
    end
=end

  end

  def self.updated_topic_notifications(topic, editor=nil)
    if editor.nil?
      editor = topic.versions.last.user
    end

    action = "edited"
    notifiable = topic
    action_type = "edit"

    (topic.followers - [editor]).each do |follower|
      Notification.notify_user(follower, editor, action,
                               notifiable, action_type)
    end
  end

  private

    def self.filter(filter, user)
      if filter == "all"
        user.notifications.all
      else
        date = 1.send(filter).ago
        user.notifications.where('created_at >= ?', date)
      end
    end
end
