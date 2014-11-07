class CreateRelationshipsTable < ActiveRecord::Migration
  def change
  	rename_table :follower_relations, :relationships 
#  	rename_column :relationships, :follower_id, :followed_id

  end
end
