class CreateUsersTableNew < ActiveRecord::Migration
  def change
  	  	change_table (:users) do |t|
  		t.string :fname
  		t.string :lname 
  		t.string :username
  		t.string :password
  		t.string :email 
  		t.string :img #path to img file
  		t.string :bio
  	end
  end
end
