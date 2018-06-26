class TopicImage < ApplicationRecord
  belongs_to :topic
  belongs_to :image
end
