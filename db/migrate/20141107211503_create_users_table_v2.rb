class CreateUsersTableV2 < ActiveRecord::Migration
  def change
  	  	create_table :users do |t|
  		t.string :fname
  		t.string :lname 
  		t.string :username
  		t.string :password
  		t.string :email 
  		t.string :bio
  	end
  end
end
