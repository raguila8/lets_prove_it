class AddDeletedOnToProblems < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :deleted_on, :datetime
  end
end
