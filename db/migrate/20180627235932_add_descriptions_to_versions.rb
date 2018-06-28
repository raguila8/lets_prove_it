class AddDescriptionsToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :description, :text
  end
end
