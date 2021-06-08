class Order < ApplicationRecord
  belongs_to :product, counter_cache: true
  #Product.find_each { |product| Product.reset_counters(product.id, :orders) }  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :orders) }  
  
  validates :user, :product, :total, :street_address, :city, :state, :zipcode, :first_name, :last_name, :phone, :email, presence: true
  validates :quantity, presence: true, numericality: { :greater_than => 0 }
  
  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  
  def generated_slug
    require 'securerandom'
    @random_slug ||=persisted? ? friendly_id : SecureRandom.hex(4)
  end
  
  def to_s
    user.to_s + " " + product.to_s
  end
  
  monetize :total, as: :total_cents, presence: true
  monetize :seller_commission, as: :seller_commission_cents, presence: true
  monetize :vendor_commission, as: :vendor_commission_cents, presence: true
  monetize :admin_commission, as: :admin_commission_cents, presence: true
  
end
