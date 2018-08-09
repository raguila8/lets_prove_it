class AddAvatarDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :avatar, :string, null: false, default: ""
  end
end
