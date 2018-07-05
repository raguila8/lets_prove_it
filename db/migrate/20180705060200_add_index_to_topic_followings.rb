class AddIndexToTopicFollowings < ActiveRecord::Migration[5.1]
  def change
    add_index :topic_followings, [:topic_id, :user_id], :unique => true
  end
end
