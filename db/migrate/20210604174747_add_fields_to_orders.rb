# frozen_string_literal: true

class AddFieldsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :seller_commission, :integer, default: '0', null: false
    add_column :orders, :vendor_commission, :integer, default: '0', null: false
    add_column :orders, :admin_commission, :integer, default: '0', null: false
    add_column :orders, :paid, :boolean, default: false, null: false
  end
end
