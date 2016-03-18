class Lottery < ActiveRecord::Base
	validates :user, presence: true, uniqueness: true
	validates :password, presence: true
end
