class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.string :image_data
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
