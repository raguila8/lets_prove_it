class CreateTopicImages < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_images do |t|
      t.belongs_to :image, index: true
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
