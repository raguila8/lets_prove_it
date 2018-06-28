class CreateVersionTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :version_topics do |t|
      t.belongs_to :version, index: true
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
