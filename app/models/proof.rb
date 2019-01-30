class Proof < ApplicationRecord
  after_create :create_activity, :add_cached_proofs_count
  before_destroy :update_activities, :subtract_cached_proofs_count

  acts_as_votable

  belongs_to :user
  belongs_to :problem
  has_many :comments, as: :commented_on, :dependent => :destroy
  has_many :versions, -> { order(created_at: :desc) }, 
             as: :versioned, dependent: :destroy
  has_many :proof_images
  has_many :images, through: :proof_images, :dependent => :destroy
  has_many :reports, as: :reportable, :dependent => :destroy

  has_many :notifications, as: :notifiable, :dependent => :destroy
  has_many :activities, as: :acted_on, :dependent => :destroy


  validates :content, presence: true, length: { maximum: 10000, minimum: 15 }
  scope :active, -> { where(deleted_on: nil) }

  def save_new(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Version.create!(versioned: self, 
                      version_number: 1, 
                      user_id: user.id, title: self.problem.title,
                      content: self.content, description: "Proof Created")

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def save_edit(images, user, version_description)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Version.create!(versioned: self, 
                      version_number: Version.next_version_number(self), 
                      user_id: user.id, title: self.problem.title,
                      content: self.content, description: version_description)

        Image.add_new_images!(self, images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

  def take_down(deleted_by, deleted_for)
    self.soft_delete deleted_by, deleted_for
  end


  def soft_deleted?
    self.deleted_on.nil? ? false : true
  end

  def soft_delete(deleted_by, deleted_for="")
    self.update(deleted_on: Time.now, deleted_by: deleted_by, 
                deleted_for: deleted_for )

    Activity.where(acted_on: self).each do |activity|
      activity.update(deleted_on: Time.now)
    end

    self.versions.each do |version|
      if version.deleted_on.nil?
        version.soft_delete("proof", 
                  "version was deleted as a result of the proof's deletion.")
      end
    end 

    self.comments.each do |comment|
      if comment.deleted_on.nil?
        comment.soft_delete("proof", "comment was deleted as a result of the proof's deletion.")
      end
    end

    # Notify original poster that proof has been deleted
    if %w(community problem).include? deleted_by
      action = "removed your proof for "
      n = Notification.new(actor_id: -1, recipient: self.user, action: action, notifiable: self, action_type: "deletion", details: deleted_for)
      n.save(validate: false)
    end

  end

  def spam_or_offensive_reports
    reports.joins(:flag_reports).where(flag_reports: {flag_id: [1, 2]}).uniq
  end

  def has_six_or_more_spam_or_offensive_flags?
    spam_or_offensive_reports.count >= 6
  end

  def spam_or_offensive?
    has_six_or_more_spam_or_offensive_flags?
  end

   
  private
 
    def create_activity
      #Activity.create(user: self.user, action: "created", acted_on: self, linkable: self)
    end

    def add_cached_proofs_count
      count = self.problem.cached_proofs_count
      self.problem.update(cached_proofs_count: count + 1)
    end

    def subtract_cached_proofs_count
      count = self.problem.proofs.count
      self.problem.update(cached_proofs_count: count - 1)
    end


end
