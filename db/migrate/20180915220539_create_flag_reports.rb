class CreateFlagReports < ActiveRecord::Migration[5.1]
  def change
    create_table :flag_reports do |t|
      t.belongs_to :flag
      t.belongs_to :report
    end

    add_index :flag_reports, [:flag_id, :report_id], :unique => true
  end
end
