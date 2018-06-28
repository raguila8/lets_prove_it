class Change < ApplicationRecord
  belongs_to :change_type
  belongs_to :version
end
