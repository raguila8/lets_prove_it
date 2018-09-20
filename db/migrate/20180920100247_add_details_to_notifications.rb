class AddDetailsToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :details, :text, default: ""
  end
end
