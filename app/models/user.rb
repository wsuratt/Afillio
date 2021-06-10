class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_secure_token :referral_token
  
  has_many :products, dependent: :nullify
  has_many :orders, dependent: :nullify
  
  def to_s
    email
  end
  
  def username
    self.email.split(/@/).first
  end
  
  extend FriendlyId
  friendly_id :email, use: :slugged
  
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
  monetize :balance, as: :balance_cents

  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end
  
end
