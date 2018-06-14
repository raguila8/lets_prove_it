class Proof < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  has_many :proof_images, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }

end
