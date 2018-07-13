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
end
