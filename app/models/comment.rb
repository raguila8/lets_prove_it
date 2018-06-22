class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :proof

  validates :content, presence: true, length: { maximum: 500, minimum: 3 }
end
