class AddSubtitleToProblems < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :subtitle, :string
  end
end
