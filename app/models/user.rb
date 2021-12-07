# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_secure_token :referral_token

  has_many :products, dependent: :nullify
  has_many :orders, dependent: :nullify
  has_many :reviews, dependent: :nullify

  def to_s
    email
  end

  def username
    email.split(/@/).first
  end

  def info_complete?
    !(vendor_title.blank? || (support_email.blank? && support_phone.blank? && support_url.blank?))
  end

  extend FriendlyId
  friendly_id :email, use: %i(slugged finders)
  def should_generate_new_friendly_id?
    email_changed?
  end

  monetize :balance, as: :balance_cents

  after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      add_role(:admin) if roles.blank?
      add_role(:seller)
      add_role(:vendor)
    elsif roles.blank?
      add_role(:seller)
    end
  end

  validate :must_have_a_role, on: :update
  validate :must_have_a_vendor_title, on: :update, if: -> { has_role?(:vendor) }
  validate :must_have_a_support, on: :update, if: -> { has_role?(:vendor) }

  # def balance_cents
  #   Rails.cache.fetch([id, :balance_cents, updated_at]) do
  #     orders.sum(:seller_commission_cents)
  #   end
  # end

  private

  def must_have_a_role
    errors.add(:roles, 'must have at least one role') unless roles.any?
  end

  def must_have_a_vendor_title
    errors.add(:vendor_title, 'must have a company name') if vendor_title.blank?
  end

  def must_have_a_support
    return if !support_email.blank? || !support_phone.blank? || !support_phone.blank?

    errors.add(:support_email, 'must have at least one form of customer support')
  end
end
