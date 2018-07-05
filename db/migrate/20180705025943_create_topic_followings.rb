class CreateTopicFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :topic_followings do |t|
      t.belongs_to :user
      t.belongs_to :topic
      t.timestamps
    end
  end
end
