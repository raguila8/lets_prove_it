class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  has_many :flag_reports, dependent: :destroy
  has_many :flags, through: :flag_reports

  validates_uniqueness_of :user_id, scope: [:reportable_type, :reportable_id]
  validates :status, presence: true
  validates :details, length: { maximum: 5000 }

  validates :reason, length: { maximum: 500 }

  def add_flags(flag_ids)
    flag_ids.each do |flag_id|
      flag = Flag.find(flag_id)
      FlagReport.create(report: self, flag: flag)
    end
  end
 
  private
end
