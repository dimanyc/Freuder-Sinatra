class DropAllTables < ActiveRecord::Migration
  def change
  	drop_table :users
  	drop_table :messages
  	drop_table :user_posts
  	#drop_table :follower_relations
  	drop_table :relationships
  end
end
