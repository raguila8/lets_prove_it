class AddUserToProblems < ActiveRecord::Migration[5.1]
  def change
    add_reference :problems, :user, index: true
  end
end
