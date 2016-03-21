class LotteriesController < ApplicationController
  def index
  	if not sesion_iniciada
  		@usuario = nil
  	else
  		@usuario = Lottery.where(id: session[:user_id]).first
  	end

  	if not sesion_admin_iniciada
  		@admin = nil
  	else
  		@admin = Lottery.where(id: session[:admin_id]).first
  	end

  end

  def login
  	if comprobar_sesiones
  		return
  	end
  end

  def checklogin
  	#nuevo = Lottery.new
  	#nuevo.user = "alex2"
  	#password = 123456
  	#nuevo.password = hash_password password.to_s
  	#nuevo.save
  	params.require(:user)
  	params.require(:password)
	
	usuario =params[:user]
	password =hash_password(params[:password])

	@usuario = Lottery.where(user: usuario, password: password, admin: false).first
	if @usuario.nil?
		flash[:notice] = "Error al iniciar sesión. Inténtelo de nuevo"
		redirect_to action: :login
	else
		session[:user_id] =  @usuario.id
		redirect_to action: :index
	end
  end

  def logout
  	if sesion_iniciada
  		session[:user_id] = 0
  		flash[:notice] = "Cerrada sesión"
  		redirect_to action: :index
  	else
  		redirect_to action: :index
  	end
  end

  def logoutadmin
  	if sesion_admin_iniciada
  		session[:admin_id] = 0
  		flash[:notice] = "Cerrada sesión"
  		redirect_to action: :index
  	else
  		redirect_to action: :index
  	end
  end

  def admin
  	if comprobar_sesiones (mensaje2 = "No puede iniciar sesión como admin si ya ha iniciado")
  		return
  	end
  end

  def checkadmin
  	if comprobar_sesiones
  		return
  	end
  	
  	params.require(:user)
  	params.require(:password)

  	usuario =params[:user]
	password =hash_password(params[:password])

	@admin = Lottery.where(user: usuario, password: password, admin: true).first

	if @admin.nil?
		flash[:notice] = "Error al iniciar sesión. Inténtelo de nuevo"
		redirect_to action: :admin
	else
		puts @admin.user
		puts @admin.id
		session[:admin_id] =  @admin.id
		redirect_to action: :index
	end
  end

 def signup
 	mensaje = "No puede crear una cuenta con una sesión abierta"
 	if comprobar_sesiones(mensaje1=mensaje, mensaje2=mensaje)
  		return
  	end
 end

 def checksignup
 	mensaje = "No puede crear una cuenta con una sesión abierta"
 	if comprobar_sesiones(mensaje1=mensaje, mensaje2=mensaje)
  		return
  	end

  	params.require(:user)
  	params.require(:password)
  	params.require(:password_repeat)

  	if params[:password]==params[:password_repeat]
  		usuario = params[:user]
  		pass = hash_password params[:password].to_s 
  		puts usuario
  		puts pass
	  	n = Lottery.new
	  	n.user = usuario
		n.password = pass
		n.save!
		flash[:notice] = "Cuenta creada correctamente\nPuede ingresar al sistema con su nueva cuenta "+ n.user
		redirect_to action: :login
	else
		flash[:notice] = "Las contraseñas no coinciden, vuelva a intentarlo"
		redirect_to action: :signup
	end
 end

#Private methods
  private 
  def comprobar_sesiones (
  		mensaje1 = "No puede entrar como admin si está logueado como usuario",
  		mensaje2 = "Ya tiene sesión de admin iniciada")
  	if sesion_iniciada
  		flash[:notice] = mensaje1
  		redirect_to action: :index
  		return true
  	end

  	if sesion_admin_iniciada
  		flash[:notice] = mensaje2
  		redirect_to action: :index
  		return true
  	end
  	return false
  end

  private
  def sesion_iniciada
  	resultado =  !session[:user_id].nil? 
  	if session[:user_id] == 0 
  		resultado = false
  	end
  	return resultado
  end


  private
  def sesion_admin_iniciada
  	resultado =  !session[:admin_id].nil? 
  	if session[:admin_id] == 0 
  		resultado = false
  	end
  	return resultado
  end

  private 
  def hash_password(pass)
  	return Digest::MD5.hexdigest pass
  end

end
