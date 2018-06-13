class CreateProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :problems do |t|
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
