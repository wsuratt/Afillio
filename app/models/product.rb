class Product < ApplicationRecord
  validates :title, :category, :quantity, :price,  presence: true
  validates :description, presence: true, length: { :minimum => 5, :maximum => 280 }
  validates :price, presence: true, numericality: { :greater_than => 0 }
  validates :commission, presence: true, numericality: { :less_than => :price, :greater_than => 0 }
  
  belongs_to :user
  
  def to_s
    title
  end
  
  extend FriendlyId
  friendly_id :title, use: :slugged
end
