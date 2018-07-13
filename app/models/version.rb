class Version < ApplicationRecord
  belongs_to :user
  has_one :problem
  has_one :topic
  has_many :version_changes, foreign_key: "version_id", class_name: "Change"
  has_many :change_types, through: :version_changes, :dependent => :destroy
  has_many :version_topics
  has_many :topics, through: :version_topics, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255, minimum: 3 }

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :description, presence: true, length: { maximum: 500, minimum: 3 }

  def get_version_topics
    it = 1
    while self.topics.empty?
      self.topics = prev_version(it).topics
      it += 1
    end
    return self.topics
  end

  def prev_version(it)
    Version.find_by(problem_id: self.problem_id, version_number: self.version_number - it)
  end
end
