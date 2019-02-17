class AddIndexToProblems < ActiveRecord::Migration[5.1]
  def change
    add_index :problems, :title, unique: true
  end
end
