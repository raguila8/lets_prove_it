class AddCachedProblemsCountToTopics < ActiveRecord::Migration[5.1]
  def change
    change_table :topics do |t|
      t.integer :cached_problems_count, default: 0
    end

  end
end
