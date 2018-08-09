class AddCachedProofsCountToProblems < ActiveRecord::Migration[5.1]
  def change
    change_table :problems do |t|
      t.integer :cached_proofs_count, default: 0
    end
  end
end
