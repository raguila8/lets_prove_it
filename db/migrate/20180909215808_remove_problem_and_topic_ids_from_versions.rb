class RemoveProblemAndTopicIdsFromVersions < ActiveRecord::Migration[5.1]
  def change
    remove_column :versions, :problem_id
    remove_column :versions, :topic_id
  end
end
