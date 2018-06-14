class CreateProblemImages < ActiveRecord::Migration[5.1]
  def change
    create_table :problem_images do |t|
      t.string :image
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true

      t.timestamps
    end
  end
end
