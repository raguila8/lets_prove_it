class ChangeProblemFollowingsNameToBookmarkedProblems < ActiveRecord::Migration[5.1]
  def change
    rename_table :problem_followings, :bookmarked_problems
  end
end
