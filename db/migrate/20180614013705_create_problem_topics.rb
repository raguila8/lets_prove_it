class CreateProblemTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_topics do |t|
      t.belongs_to :problem, index: true
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
