class AddDeletedOnToCommentsAndProofs < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :deleted_on, :datetime
    add_column :proofs, :deleted_on, :datetime
  end
end
