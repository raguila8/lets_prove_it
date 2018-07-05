class CreateProblemFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_followings do |t|
      t.belongs_to :user
      t.belongs_to :problem
      t.timestamps
    end
  end
end
