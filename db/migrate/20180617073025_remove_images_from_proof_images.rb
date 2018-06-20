class RemoveImagesFromProofImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :proof_images, :image
    remove_column :proof_images, :user_id
    add_reference :proof_images, :image, index: true
  end
end
