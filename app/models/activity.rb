class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :acted_on, polymorphic: true
  belongs_to :linkable, polymorphic: true

  def linkable?
    not linkable.nil?
  end

  def link
    if linkable?
      "/#{linkable_type.pluralize.downcase}/#{linkable.id}"
    end
  end

  def message
    model_in_question = (acted_on_type == "Version" ? linkable_type : acted_on_type)
    "<a href='/users/#{self.user.id}'>#{self.user.username}</a> #{action} #{model_in_question.downcase}".html_safe
  end

  def deleted_message
    model_in_question = (acted_on_type == "Version" ? linkable_type : acted_on_type)
    "#{model_in_question} was deleted on #{deleted_on.strftime('%B %d, %Y')}"
  end

end
