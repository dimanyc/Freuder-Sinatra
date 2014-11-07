class User < ActiveRecord::Base
	has_many :messages
	has_many :relationships, foreign_key: :follower_id
	has_many :followed, through: :relationships, source: :followed
	
	#reverse - followers per user
	has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
	has_many :followers, through: :reverse_relationships, source: :follower

	#one user to follow another 
	def follow!(user)
		followed << user 
	end

end

class Message < ActiveRecord::Base
	belongs_to :user
end

class Relationship < ActiveRecord::Base
	belongs_to :followed, class_name: 'User'
	belongs_to :follower, class_name: 'User'
end
