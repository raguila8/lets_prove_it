class CreateReservedReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reserved_reports do |t|
      t.integer :user_id
      t.integer :report_id

      t.timestamps
    end
    add_index :reserved_reports, :user_id
    add_index :reserved_reports, :report_id
    add_index :reserved_reports, [:user_id, :report_id], unique: true
  end
end
