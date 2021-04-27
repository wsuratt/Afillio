class Product < ApplicationRecord
  validates :title,  presence: true
  validates :description, presence: true, length: { :minimum => 5, :maximum => 280 }
  def to_s
    title
  end
end
