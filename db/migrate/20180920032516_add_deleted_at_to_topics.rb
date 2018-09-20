class AddDeletedAtToTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :deleted_on, :datetime
  end
end
