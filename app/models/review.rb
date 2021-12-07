# frozen_string_literal: true

class Review < ApplicationRecord
  validates :rating, presence: true

  belongs_to :user
end
