class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, ->{ where(read_at: nil) }  

  def is_read?
    !self.read_at.nil?
  end

  def link
    if self.notifiable_type == "Problem"
      "/problems/#{self.notifiable.id}"
    elsif self.notifiable_type == "User"
      "/users/#{self.notifiable.id}"
    elsif self.notifiable_type == "Topic"
      "/topics/#{self.notifiable.id}"
    end
  end

  def message
    message = self.action
    if self.notifiable_type == "Problem"
      message += " problem <i style='text-transform: none;'>#{self.notifiable.title.titleize}</i>"
    elsif self.notifiable_type == "User"
      message += " you"
    elsif self.notifiable_type == "Topic"
      message += " topic <i style='text-transform: none;'>#{self.notifiable.name.titleize}</i>".html_safe
    end
    message.html_safe
  end

  def self.notify_user(recipient, actor, action, notifiable)
    Notification.create(recipient: recipient, actor: actor, action: action, notifiable: notifiable)
  end

  def self.notify_user_of_vote(actor, voted_on)
    if voted_on.class.name == "Problem"
      # Notify problem editors that the problem has been liked/disliked
      ((voted_on.versions.map{ |version| version.user }).uniq - [actor]).each do |editor|
        Notification.notify_user(editor, actor, "liked", voted_on) if editor != actor
      end
    elsif voted_on.class.name == "Comment"
      # Notify owner of comment 
      Notification.notify_user(voted_on.user, actor, "liked your comment on a proof for", voted_on.proof.problem) if voted_on.user != actor
    elsif voted_on.class.name == "Proof"
      # Notify owner of proof
      Notification.notify_user(voted_on.user, actor, "liked your proof for", voted_on.problem) if voted_on.user != actor
    end
  end

  def self.remove_vote_notification(actor, voted_on)
    if voted_on.class.name == "Problem"
      # Remove notifications from problem editors
      ((voted_on.versions.map{ |version| version.user }).uniq - [actor]).each do |editor|
        n = Notification.find_by(recipient: editor, 
                                 actor: actor, 
                                 action: "liked", 
                                 notifiable: voted_on) if editor != actor
        n.destroy if !n.nil?
      end
    elsif voted_on.class.name == "Comment"
      # Remove notification from owner of comment 
      n = Notification.find_by(recipient: voted_on.user, actor: actor, 
                action: "liked your comment on a proof for", 
                notifiable: voted_on.proof.problem) if voted_on.user != actor
      n.destroy if !n.nil?
    elsif voted_on.class.name == "Proof"
      # Remove notifications from  owner of proof
      n = Notification.find_by(recipient: voted_on.user, actor: actor, 
                action: "liked your proof for", 
                notifiable: voted_on.problem) if voted_on.user != actor
      n.destroy if !n.nil?
    end

  end
end
