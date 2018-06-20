class Proof < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  has_many :comments, :dependent => :destroy
  has_many :proof_images, :dependent => :destroy
  has_many :images, through: :proof_images

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }

end
