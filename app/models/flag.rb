class Flag < ApplicationRecord
  has_many :flag_reports, dependent: :destroy
  has_many :reports, through: :flag_reports
  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :reportable_type, presence: true, inclusion: { in: ["all", "problem", "comment", "proof", "problem and proof"] }
  validates :description, presence: true
  

  def self.validate_flags(flags, reason)
    return "No flags have been selected" if flags.nil?
    return "Invalid flags" if flags.uniq.length != flags.length
    flags.each do |flag_id|
      return "Invalid flags" if !Flag.exists?(flag_id)
      if Flag.find(flag_id).name == "other" and reason.empty?
        return "Reason you are reporting post can't be blank." 
      end
    end
    return ""
  end
end
