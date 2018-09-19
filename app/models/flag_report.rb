class FlagReport < ApplicationRecord
  belongs_to :report
  belongs_to :flag

  validates_uniqueness_of :report_id, scope: [:flag_id]
end
