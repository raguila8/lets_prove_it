class Proof < ApplicationRecord
  acts_as_votable

  belongs_to :user
  belongs_to :problem
  has_many :comments, :dependent => :destroy
  has_many :proof_images
  has_many :images, through: :proof_images, :dependent => :destroy

  validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
  validates_uniqueness_of :user_id, :scope => [:problem_id]


  
  def save_with_images(images, user)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        Image.add_new_images!("proof", images, user)
      end

    rescue ActiveRecord::RecordInvalid => exception
      return { exception: exception }
    rescue Exceptions::ImagesFieldInvalid => exception
      return { exception: exception }
    end

    return { }
  end

end
