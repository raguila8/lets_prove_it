class AddLastSeenAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_seen_at, :datetime, default: Time.now
  end
end
