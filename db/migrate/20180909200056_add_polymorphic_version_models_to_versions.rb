class AddPolymorphicVersionModelsToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :versioned_id, :integer
    add_column :versions, :versioned_type, :string

    add_index :versions, :versioned_id
    add_index :versions, [:versioned_id, :versioned_type]
  end
end
