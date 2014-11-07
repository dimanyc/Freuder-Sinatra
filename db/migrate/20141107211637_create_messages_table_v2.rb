class CreateMessagesTableV2 < ActiveRecord::Migration
  def change
  	  	create_table :messages do |t|
  		t.string :user_id
  		t.string :title
  		t.string :message 
  		t.timestamps :date
  	end
  end
end
