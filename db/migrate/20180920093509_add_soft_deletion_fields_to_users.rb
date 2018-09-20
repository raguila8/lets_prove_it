class AddSoftDeletionFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :deleted_on, :datetime
    add_column :users, :deleted_by, :string
    add_column :users, :deleted_for, :text
  end
end
