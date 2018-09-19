class AddExpiredAtToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :expired_on, :datetime
  end
end
