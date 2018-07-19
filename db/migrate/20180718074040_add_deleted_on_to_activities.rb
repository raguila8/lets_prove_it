class AddDeletedOnToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :deleted_on, :datetime
  end
end
