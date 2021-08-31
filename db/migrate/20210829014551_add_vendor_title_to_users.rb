class AddVendorTitleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :vendor_title, :string
  end
end
