class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:reportable_type, :reportable_id]

  validates :reason, presence: true, length: { minimum: 3, maximum: 500 }
end
