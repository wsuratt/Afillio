# frozen_string_literal: true

class AddTrackingNumberToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :tracking_number, :string
  end
end
