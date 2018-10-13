class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  validates :action_type, presence: true, length: { minimum: 3, maximum: 70 }
  validates :details, length: { maximum: 500 }
  validates :action, presence: true, length: { minimum: 3, maximum: 70 }

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

  
  
  def self.feed(options = { user: nil })
    options[:filter] = "all" if options[:filter].nil?
    options[:sorter] = "created_at" if options[:sorter].nil?
    self.filter(options[:filter], options[:user]).order("#{options[:sorter]} DESC")
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
