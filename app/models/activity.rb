class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :acted_on, polymorphic: true

  def link
    if acted_on_type == "Problem"
      "/problems/#{acted_on.id}"
    elsif acted_on_type == "User"
      "/users/#{acted_on.id}"
    elsif acted_on_type == "Topic"
      "/topics/#{acted_on.id}"
    elsif acted_on_type == "Comment"
      "/problems/#{acted_on.proof.problem.id}"
    elsif acted_on_type == "Proof"
      "/problems/#{acted_on.problem.id}"
    end
  end 

end
