class CreateProofs < ActiveRecord::Migration[5.1]
  def change
    create_table :proofs do |t|
      t.text :content
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true

      t.timestamps
    end
  end
end
