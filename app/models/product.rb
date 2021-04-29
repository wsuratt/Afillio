class Product < ApplicationRecord
  validates :title,  presence: true
  validates :description, presence: true, length: { :minimum => 5, :maximum => 280 }
  
  belongs_to :user
  
  def to_s
    title
  end
  
  extend FriendlyId
  friendly_id :title, use: :slugged
end
