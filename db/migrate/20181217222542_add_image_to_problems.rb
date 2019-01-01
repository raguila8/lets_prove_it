class AddImageToProblems < ActiveRecord::Migration[5.1]
  def change
    add_column :problems, :image, :string
  end
end
