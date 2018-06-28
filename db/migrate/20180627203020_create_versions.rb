class CreateVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :versions do |t|
      t.integer :problem_id, index: true
      t.integer :topic_id, index: true
      t.integer :version_number
      t.belongs_to :user

      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
