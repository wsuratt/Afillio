class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user
  
  validates :user, :product, :total, :street_address, :city, :state, :zipcode, :first_name, :last_name, :phone, :email, presence: true
  validates :quantity, presence: true, numericality: { :greater_than => 0 }
  
  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  
  def generated_slug
    require 'securerandom'
    @random_slug ||=persisted? ? friendly_id : SecureRandom.hex(4)
  end
  
  def to_s
    user.to_s + " " + course.to_s
  end
  
end
