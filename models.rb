class User < ActiveRecord::Base
	has_many :messages
end

class Message < ActiveRecord::Base
	belongs_to :user
end