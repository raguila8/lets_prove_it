class AddIndexToProblemFollowings < ActiveRecord::Migration[5.1]
  def change
    add_index :problem_followings, [:problem_id, :user_id], :unique => true
  end
end
