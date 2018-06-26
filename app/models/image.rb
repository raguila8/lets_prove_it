class Image < ApplicationRecord
  mount_uploader :image_data, ImageUploader
  has_many :problem_images, :dependent => :destroy
  has_many :proof_images, :dependent => :destroy

  def belongs_to_a_model?
    ProblemImage.exists?(self.id) || ProofImage.exists?(self.id) || TopicImage.exists?(self.id)
  end

  def self.add_new_images!(model, images, user)
    if images.length >= 1
      images.each do |id|
        if !Image.exists?(id.to_i)
          raise Exceptions::ImagesFieldInvalid.new, "Images field is invalid"
        end
        image = Image.find(id)
        if image.belongs_to_a_model?
          raise Exceptions::ImagesFieldInvalid.new, "Images field is invalid"
        end
        if image.user != user
          raise Exceptions::ImagesFieldInvalid.new, "Images field is invalid"
        end
        if model == "problem"
          ProblemImage.create!(problem_id: self.id, image_id: image.id)
        elsif model == "proof"
          ProofImage.create!(proof_id: self.id, image_id: image.id)
        elsif model == "topic"
          TopicImage.create!(topic_id: self.id, image_id: image.id)
        end
      end
    end

  end

  def self.add_new_images(model, images, user)
    if images.length >= 1
      images.each do |id|
        if !Image.exists?(id.to_i)
          next
        end
        image = Image.find(id)
        if image.belongs_to_a_model?
          next
        end
        if image.user != user
          next
        end

        if model == "problem"
          ProblemImage.create(problem_id: self.id, image_id: image.id)
        elsif model == "proof"
          ProofImage.create(proof_id: self.id, image_id: image.id)
        elsif model == "topic"
          TopicImage.create(topic_id: self.id, image_id: image.id)
        end
      end
    end

  end

end
