class Lottery < ActiveRecord::Base
	validates :user, presence: true, uniqueness: true, length: {minimum: 5, maximum: 20}, :allow_blank => false
	validates :password, presence: true
end
