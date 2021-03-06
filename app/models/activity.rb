class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :acted_on, polymorphic: true
  belongs_to :linkable, polymorphic: true
  validates :action, presence: true, length: { minimum: 3, maximum: 70 }
  scope :active, -> { where(deleted_on: nil) }


  def linkable?
    not linkable.nil?
  end

  def link
    if linkable?
      "/#{linkable_type.pluralize.downcase}/#{linkable.id}"
    end
  end

  def message
    if acted_on_type == "Comment" and action == "created"
        model_in_question = (self.acted_on.nil? ? "post" : self.acted_on.commented_on_type.downcase)
        "<a href='/users/#{self.user.id}'>#{self.user.username}</a> commented on a #{model_in_question}".html_safe
    else
      model_in_question = (acted_on_type == "Version" ? linkable_type : acted_on_type)
      "<a href='/users/#{self.user.id}'>#{self.user.username}</a> #{action} #{model_in_question.downcase}".html_safe
    end
  end

  def deleted_message
    model_in_question = (acted_on_type == "Version" ? linkable_type : acted_on_type)
    "#{model_in_question} was deleted on #{deleted_on.strftime('%B %d, %Y')}"
  end

  def soft_deleted?
    self.deleted_on.nil? ? false : true
  end
end
