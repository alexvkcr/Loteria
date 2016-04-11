class User < ActiveRecord::Base
	validates :user, presence: true, uniqueness: true, length: {minimum: 4, maximum: 20}
	validates :password, presence: true
end
