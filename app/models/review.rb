class Review < ApplicationRecord
  validates :rating, presence: true
  
  belongs_to :user
end
