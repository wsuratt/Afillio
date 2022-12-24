class AddCtaToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :cta, :string
  end
end
