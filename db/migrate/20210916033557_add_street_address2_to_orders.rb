# frozen_string_literal: true

class AddStreetAddress2ToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :street_address2, :string
  end
end
