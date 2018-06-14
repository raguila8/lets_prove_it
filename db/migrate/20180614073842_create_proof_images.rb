class CreateProofImages < ActiveRecord::Migration[5.1]
  def change
    create_table :proof_images do |t|
      t.string :image
      t.belongs_to :user, index: true
      t.belongs_to :proof, index: true

      t.timestamps
    end
  end
end
