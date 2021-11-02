class Product < ApplicationRecord
  validates :title, :category, presence: true
  validates :show, inclusion: { in: [ true, false ] }
  validates :description, presence: true, length: { :minimum => 5, :maximum => 280 }
  validates :quantity, presence: true, numericality: { :greater_than_or_equal_to => 0, :only_integer => true }
  # validates :price, presence: true, numericality: { :greater_than => 0 }
  # validates :commission, presence: true, numericality: { :less_than_or_equal_to => :price, :greater_than => 0 }
  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :products) }  
  has_many :orders, dependent: :restrict_with_error
  
  validates :title, uniqueness: true
  
  scope :latest, -> { limit(4).order(created_at: :desc) }
  scope :popular, -> { limit(4).order(orders_count: :desc, created_at: :desc) }
  scope :active, -> { where(show: true) }
  
  has_one_attached :image
  validates :image, attached: true, 
    content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
    size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }
  
  def to_s
    title
  end
  
  def filter_products
    self.reject { |a| a[:show] }
  end
  
  monetize :price, as: :price_cents, presence: true, numericality: { :greater_than => 0 }
  monetize :commission, as: :commission_cents, presence: true, numericality: { :less_than_or_equal_to => Proc.new {|product| product.price_cents - product.price_cents * 0.03 }, :greater_than => 0 }
  
  extend FriendlyId
  friendly_id :title, use: %i(slugged finders)
  def should_generate_new_friendly_id?
    title_changed?
  end
  
  CATEGORIES = [:"Apparel", :"Beauty", :"Education", :"Health", :"Home", :"Outdoors", :"Tech", :"Toys", :"Other"]
  def self.categories
    CATEGORIES.map { |category| [category, category] }
  end
end
