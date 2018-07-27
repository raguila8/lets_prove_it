class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.string :reason
      t.integer :reportable_id
      t.string :reportable_type
      t.datetime :read_at

      t.timestamps
    end

    add_index :reports, :user_id
    add_index :activities, :reportable_id
  end
end
