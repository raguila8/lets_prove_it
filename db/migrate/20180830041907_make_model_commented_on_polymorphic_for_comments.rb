class MakeModelCommentedOnPolymorphicForComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :commented_on_id, :integer
    add_column :comments, :commented_on_type, :string

    add_index :comments, :commented_on_id
  end
end
