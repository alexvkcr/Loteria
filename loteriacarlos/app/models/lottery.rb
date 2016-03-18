class Lottery < ActiveRecord::Base
validates :email, presence: true , uniqueness: true
validates :contraseña, presence:true, uniqueness:true, length: {minimum:5}
validates :usuario, presence: true, uniqueness:true, length: {maximum:10}
validates :luckynumber, presence:true, :numericality=> {:greater_than =>0, :less_than_or_equal_to => 10}
validates :genero , presence:true
end
