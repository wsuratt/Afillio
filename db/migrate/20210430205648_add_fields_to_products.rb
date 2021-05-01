class AddFieldsToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :category, :string, default: "Other", null: false;
    add_column :products, :quantity, :integer, default: "0", null: false;
    add_column :products, :price, :integer, default: "0", null: false;
    add_column :products, :commission, :integer, default: "0", null: false;
  end
end
