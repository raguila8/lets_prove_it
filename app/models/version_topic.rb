class VersionTopic < ApplicationRecord
  belongs_to :version
  belongs_to :topic
end
