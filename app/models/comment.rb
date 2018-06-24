class Comment < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :proof

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }
end
