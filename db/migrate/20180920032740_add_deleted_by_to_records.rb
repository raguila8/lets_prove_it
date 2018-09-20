class AddDeletedByToRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :deleted_by, :string
    add_column :proofs, :deleted_by, :string
    add_column :topics, :deleted_by, :string
    add_column :versions, :deleted_by, :string
  end
end
