class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :return_url, :string
    add_column :users, :support_email, :string
    add_column :users, :support_phone, :string
    add_column :users, :support_url, :string
    add_column :users, :website_url, :string
    add_column :users, :instagram, :string
  end
end
