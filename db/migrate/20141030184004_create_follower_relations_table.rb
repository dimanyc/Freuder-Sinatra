class CreateFollowerRelationsTable < ActiveRecord::Migration
  def change
  	create_table :follower_relations do |t|
  	t.integer :followee_id
  	t.integer :follower_id 
  	end  	
  end
end
