class AddReputationToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :reputation, default: 0
    end
  end
end
