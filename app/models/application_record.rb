class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def update_activities
    Activity.where(acted_on: self).each do |activity|
      activity.update(deleted_on: Time.now)
    end
  
    if self.class.name == "Proof" || self.class.name == "Comment"
      linkable = (self.class.name == "Comment" ? self.proof.problem : self.problem)
      Activity.create(user: self.user, action: "deleted", acted_on: self, deleted_on: Time.now, linkable: linkable)
    end 
  end

end
