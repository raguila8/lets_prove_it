class RemoveImagesFromProblemImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :problem_images, :image
    remove_column :problem_images, :user_id
    add_reference :problem_images, :image, index: true
  end
end
