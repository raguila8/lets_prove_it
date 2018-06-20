class Image < ApplicationRecord
  mount_uploader :image_data, ImageUploader
  has_many :problem_images, :dependent => :destroy
  has_many :proof_images, :dependent => :destroy
end
