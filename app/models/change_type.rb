class ChangeType < ApplicationRecord
  has_many :version_changes, foreign_key: "change_type_id", class_name: "Change"
  has_many :versions, through: :version_changes, dependent: :destroy
end
