# frozen_string_literal: true

class AddCounterCacheFields < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :orders_count, :integer, null: false, default: 0
    add_column :users, :products_count, :integer, null: false, default: 0
    add_column :users, :orders_count, :integer, null: false, default: 0
  end
end
