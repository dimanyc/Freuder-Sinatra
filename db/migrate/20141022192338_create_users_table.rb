class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname 
  		t.string :username
  		t.string :password
  		t.string :email 
  		t.string :img #path to img file
  	end
  end
end
