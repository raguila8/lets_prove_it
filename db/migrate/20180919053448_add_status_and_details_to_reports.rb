class AddStatusAndDetailsToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :status, :string, null: false, default: ""
    add_column :reports, :details, :text, default: ""
  end
end
