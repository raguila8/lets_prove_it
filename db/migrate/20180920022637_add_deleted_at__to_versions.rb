class AddDeletedAtToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :deleted_on, :datetime
  end
end
