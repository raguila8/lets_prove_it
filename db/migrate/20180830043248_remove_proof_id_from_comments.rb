class RemoveProofIdFromComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :proof_id
  end
end
