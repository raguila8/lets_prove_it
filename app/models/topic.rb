class Topic < ApplicationRecord

  has_many :topic_images
  has_many :images, through: :topic_images, :dependent => :destroy

  before_save { self.name = name.upcase }
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }
end
