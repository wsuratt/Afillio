# frozen_string_literal: true

class Product < ApplicationRecord
  validates :title, :category, presence: true, length: { maximum: 105 }
  validates :show, inclusion: { in: [true, false] }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :cta, presence: true, length: { maximum: 20 }

  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :products) }
  has_many :orders, dependent: :restrict_with_error

  validates :title, uniqueness: true

  scope :latest, -> { limit(4).order(created_at: :desc) }
  scope :popular, -> { limit(4).order(orders_count: :desc, created_at: :desc) }
  scope :active, -> { where(show: true) }

  has_many_attached :images
  validates :images, attached: true,
                     content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                     size: { less_than: 500.kilobytes,
                             message: 'size should be under 500 kilobytes' }

  validate :validate_images

  has_many_attached :videos
  validates :videos, attached: true,
                     content_type: ['video/mp4'],
                     size: { less_than: 5.megabytes,
                             message: 'size should be under 5 megabytes' }

  validate :validate_videos

  has_rich_text :description

  def to_s
    title
  end

  def filter_products
    reject { |a| a[:show] }
  end

  monetize :price, as: :price_cents, presence: true, numericality: { greater_than: 0 }
  monetize :commission,
           as: :commission_cents,
           presence: true,
           numericality:
           {
             less_than_or_equal_to: proc { |product|
               product.price_cents - (product.price_cents * 0.03)
             },
             greater_than: 0
           }

  extend FriendlyId
  friendly_id :title, use: %i(slugged finders)
  def should_generate_new_friendly_id?
    title_changed?
  end

  CATEGORIES = %i(Apparel Beauty Education Health Home Outdoors Tech Toys Other).freeze
  def self.categories
    CATEGORIES.map { |category| [category, category] }
  end

  private

  def validate_images
    return if images.count / 2 <= 3

    errors.add(:images, 'limit is a maximum of 3')
  end

  def validate_videos
    return if videos.count / 2 <= 1

    errors.add(:videos, 'limit is a maximum of 1')
  end
end
