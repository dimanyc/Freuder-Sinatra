class RenamingFolloweeColumnToFollowed < ActiveRecord::Migration
  def change
  	rename_column :relationships, :followee_id, :follower_id
  end
end
