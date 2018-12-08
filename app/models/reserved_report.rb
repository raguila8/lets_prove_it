class ReservedReport < ApplicationRecord
  belongs_to :report
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:report_id]
end
