class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.string :action
      t.integer :acted_on_id
      t.string :acted_on_type

      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :acted_on_id
  end
end
