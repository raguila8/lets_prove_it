class Problem < ApplicationRecord
  belongs_to :user
  has_many :proofs, :dependent => :destroy
  has_many :problem_images, :dependent => :destroy
  has_many :problem_topics
  has_many :topics, through: :problem_topics, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates :title, presence: true, uniqueness: { case_sensitive: false }, 
                    length: { maximum: 255, minimum: 3 }
end
