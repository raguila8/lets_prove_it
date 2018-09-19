class AddDeletedByToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :deleted_by, :string, default: "user"
  end
end
