class Version < ApplicationRecord
  has_one :problem
  has_one :topic
  has_many :version_changes, foreign_key: "version_id", class_name: "Change"
  has_many :change_types, through: :version_changes, :dependent => :destroy
  has_many :version_topics
  has_many :topics, through: :version_topics, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255, minimum: 3 }

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :description, presence: true, length: { maximum: 500, minimum: 3 }

end
