class Proof < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  has_many :comments, :dependent => :destroy
  has_many :proof_images
  has_many :images, through: :proof_images, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }


  def add_new_images(current_user)
    current_user.images.each do |image|
      if !ProofImage.find_by(image_id: image.id)
        ProofImage.create(proof_id: self.id, image_id: image.id)
      end
    end
  end
end
