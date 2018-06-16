class Topic < ApplicationRecord
  before_save { self.name = name.upcase }
  validates :name, presence: true, length: { minimum: 3 }
end
