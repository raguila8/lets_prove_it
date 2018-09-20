class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  has_many :flag_reports, dependent: :destroy
  has_many :flags, through: :flag_reports

  #validates_uniqueness_of :user_id, scope: [:reportable_type, :reportable_id]
  validate :only_one_active
  validates :status, presence: true
  validates :details, length: { maximum: 5000 }

  validates :reason, length: { maximum: 500 }

  scope :active, -> { where(expired_on: nil) }

  def add_flags(flag_ids)
    flag_ids.each do |flag_id|
      flag = Flag.find(flag_id)
      FlagReport.create(report: self, flag: flag)
    end
  end

  def self.handle(post)
    if Report.automatic_deletion? post
      allowed_flags = (post.class.name == "Comment" ? 3 : 6)
      post.take_down("community", "#{post.class.name.downcase} was flagged as spam and/or offensive #{allowed_flags} or more times")
    end
  end
 
  private

    def self.automatic_deletion?(post)
      if post.class.name == "Comment"
        if post.reports.active.count >= 3 and post.cached_votes_score <= 0
          return true
        end
      elsif %w(Problem Proof).include? post.class.name
        if post.reports.active.joins(:flag_reports).where(flag_reports: {flag_id: [1, 2]}).count >= 6
          return true
        end
      end
      return false
    end

    def only_one_active
      if expired_on.nil? and !Report.find_by(user_id: user.id, reportable_type: reportable_type, 
                        reportable_id: reportable_id, expired_on: nil).nil?
        errors.add(:base, "should only have one active report")
      end
    end
end
