# frozen_string_literal: true

class AddUserToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :user, null: false, foreign_key: true
  end
end
