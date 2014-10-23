class CreateMessagesTable < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.string :user_id
  		t.string :message 
  		t.string :category # categorizing messages by interest(s)
  		t.string :tag1 # tags for additional categorization
  		t.string :tag2
  		t.string :tag3 
  		t.timestamps :date


  	end
  end
end
