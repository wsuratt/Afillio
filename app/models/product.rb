class Product < ApplicationRecord
  validates :title, :category, :quantity, :price,  presence: true
  validates :description, presence: true, length: { :minimum => 5, :maximum => 280 }
  validates :price, presence: true, numericality: { :greater_than => 0 }
  validates :commission, presence: true, numericality: { :less_than_or_equal_to => :price, :greater_than => 0 }
  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :products) }  
  has_many :orders, dependent: :restrict_with_error
  
  validates :title, uniqueness: true
  
  scope :latest, -> { limit(2).order(created_at: :desc) }
  scope :popular, -> { limit(2).order(orders_count: :desc, created_at: :desc) }
  
  def to_s
    title
  end
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  CATEGORIES = [:"Other", :"Tech", :"Apparel"]
  def self.categories
    CATEGORIES.map { |category| [category, category] }
  end
  
end
