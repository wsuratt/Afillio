class AddShowToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :show, :boolean, default: true
  end
end
