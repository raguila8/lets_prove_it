class CreateFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.string :name, null: false, unique: true
      t.string :reportable_type, null: false
    end
  end
end
