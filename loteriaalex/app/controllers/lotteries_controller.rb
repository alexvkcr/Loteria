class LotteriesController < ApplicationController
  def index
  	if not sesion_iniciada
  		@usuario = nil
  	else
  		@usuario = Lottery.where(id: session[:user_id]).first
  	end
  end

  def login
  	if not sesion_iniciada
  		render "index"
  	end
  end

  def checklogin
  	#nuevo = Lottery.new
  	#nuevo.user = "alex"
  	#password = 123456
  	#nuevo.password = hash_password password.to_s
  	#id = nuevo.save
  	if sesion_iniciada
  		render "index"
  		@usuario = Lottery.where(id: session[:user_id]).first
  	else
  		usuario =params[:user]
  		password =hash_password(params[:password])

  		@usuario = Lottery.where(user: usuario, password: password, admin: false).first
  		if @usuario.nil?
  			render "login"
  		else
  			session[:user_id] =  @usuario.id
  			render "index"
  		end
	end
  end

  def logout

  end

  private
  def sesion_iniciada
  	return (not session[:user_id].nil?) || session[:user_id] != 0 
  end

  private 
  def hash_password(pass)
  	return Digest::MD5.hexdigest pass
  end

end
