class CreateChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :changes do |t|
      t.belongs_to :version, index: true
      t.belongs_to :change_type, index: true

      t.timestamps
    end
  end
end
