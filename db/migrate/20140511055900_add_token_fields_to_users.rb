class AddTokenFieldsToUsers < ActiveRecord::Migration
  def change
	  add_column :users, :access_token, :string
	  add_column :users, :access_secret, :string
	  add_column :users, :password_500px, :string
  end
end