class User < ActiveRecord::Base
	has_many :messages
	has_many :follower_relations, foreign_key: :follower_id
	has_many :followee, through: :follower_relations, source: :followee

end

class Message < ActiveRecord::Base
	belongs_to :user
end

class FollowerRelation < ActiveRecord::Base
	belongs_to :followee, class_name: 'User'
end
