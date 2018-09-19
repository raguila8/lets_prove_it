class AddDescriptionToFlags < ActiveRecord::Migration[5.1]
  def change
    add_column :flags, :description, :text
  end
end
