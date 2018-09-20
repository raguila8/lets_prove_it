class AddDeletedForToMultipleTables < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :deleted_for, :text
    add_column :proofs, :deleted_for, :text
    add_column :topics, :deleted_for, :text
    add_column :versions, :deleted_for, :text
    add_column :comments, :deleted_for, :text
  end
end
