class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, UserImageUploader


  has_many :topics, through: :user_topics, :dependent => :destroy
  has_many :proofs, :dependent => :destroy
  has_many :problem_images, :dependent => :destroy
  has_many :proof_images, :dependent => :destroy

  validates :email, presence: true, length: { maximum: 255 },
										uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 70 }
  validates :username, presence: true, length: { minimum: 5, maximum: 18 },
											uniqueness: true
  validate :avatar_size


  private
	
		# Validates the size of an uploaded image
		def avatar_size
			if self.avatar.size > 5.megabytes
				errors.add(:avatar, "should be less than 5MB")
			end
		end

end
