class AddLinkableToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :linkable_id, :integer
    add_column :activities, :linkable_type, :string
    add_index :activities, :linkable_id
  end
end
