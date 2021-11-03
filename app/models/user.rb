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
    self.email.split(/@/).first
  end
  
  def info_complete?
    if self.vendor_title.blank? || (self.support_email.blank? && self.support_phone.blank? && self.support_url.blank?)
      return false
    else
      return true
    end
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
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:seller)
      self.add_role(:vendor)
    else
      self.add_role(:seller) if self.roles.blank?
    end
  end
  
  validate :must_have_a_role, on: :update
  validate :must_have_a_vendor_title, on: :vendor_info_update
  validate :must_have_a_support, on: :vendor_info_update
  
  # def balance_cents
  #   Rails.cache.fetch([id, :balance_cents, updated_at]) do
  #     orders.sum(:seller_commission_cents)
  #   end
  # end

  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end
  
  def must_have_a_vendor_title
    unless !vendor_title.blank?
      errors.add(:vendor_title, "must have a company name")
    end
  end
  
  def must_have_a_support
    unless !support_email.blank? || !support_phone.blank? || !support_phone.blank?
      errors.add(:support_email, "must have at least one form of customer support")
    end
  end
  
end
