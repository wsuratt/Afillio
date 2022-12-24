class AddSalePriceToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :sale_price, :integer, default: '0', null: false
  end
end
