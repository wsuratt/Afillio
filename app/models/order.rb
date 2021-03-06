# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :product, counter_cache: true
  # Product.find_each { |product| Product.reset_counters(product.id, :orders) }
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :orders) }
  default_scope { order(created_at: :desc) }

  validates :user,
            :product,
            :total,
            :street_address,
            :city,
            :state,
            :zipcode,
            :first_name,
            :last_name,
            :phone, :email,
            presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  extend FriendlyId
  friendly_id :generated_slug, use: :slugged

  def generated_slug
    require 'securerandom'
    @generated_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    "#{user} #{product}"
  end

  def self.stripe_fee
    fee = 0.30 # 30 cents
    fee.freeze
  end

  def self.stripe_fee_cents
    fee = Money.new(00_01, 'USD') * 30 # 30 cents
    fee.freeze
  end

  def self.afillio_fee
    fee = 0.03.to_f
    fee.freeze
  end

  monetize :total, as: :total_cents, presence: true
  monetize :seller_commission, as: :seller_commission_cents, presence: true
  monetize :vendor_commission, as: :vendor_commission_cents, presence: true
  monetize :admin_commission, as: :admin_commission_cents, presence: true
end
