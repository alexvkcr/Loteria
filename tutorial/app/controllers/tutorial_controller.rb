class TutorialController < ApplicationController

  def index
  	if not sesion_iniciada
  		@usuario = nil
  	else
      @usuario = User.find_by(id: session[:user_id])
  	end

  	if not sesion_admin_iniciada
  		@admin = nil
  	else
  		@admin = User.find_by(id: session[:admin_id])
  	end

  end

  private
  def sesion_iniciada
  	# resultado =  !session[:user_id].nil? #Está definiendo resultado, y pregunta cuando será nula la sesión
  	resultado = true

  	if session[:user_id] == 0 || session[:user_id] == nil #La sesión será nula cuando sea = 0 
  		resultado = false 
  	end
  	return resultado
  end


  private
  def sesion_admin_iniciada
  	resultado =  !session[:admin_id].nil? #La exclamación antes de session, significa que niega el resultado
  	if session[:admin_id] == 0 #Aquí dices que si el id del admin es 0 el resultado será negativo
  		resultado = false #Ponemos que el resultado será false -> y como hay una negación sí será nula.
  	end
  	return resultado
  end

  def login
  	if comprobar_sesiones
  		return
  	end
  end


  private 
  def comprobar_sesiones (
  		mensaje1 = "Ya está registrado como usuario, no puede iniciar una nueva sesión",
  		mensaje2 = "Ya está registrado como administrador, no puede iniciar una nueva sesión")
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

  public
  def checklogin

    usuario= params[:user]
    password=params[:password]

  	@usuario = User.find_by(user: usuario, password: password, admin: false)

  	if @usuario.nil?
  		flash[:notice] = "Error al iniciar sesión. Inténtelo de nuevo"
  		redirect_to action: :login
  	else
  		session[:user_id] =  @usuario.id
  		redirect_to action: :index
  	end
  end

public
  def checkadmin
    
    usuario = params[:user]
    password = params[:password]

    @admin = User.find_by(user: usuario, password: password, admin: true)

    if @admin.nil?
      flash[:notice] = "Error al iniciar sesión. Inténtelo de nuevo"
      redirect_to action: :login
    else
      session[:admin_id] =  @admin.id
      redirect_to action: :index
    end
  end

public
  def logout_usuario
    if sesion_iniciada
      session[:user_id] = 0
      flash[:notice] = "Fin de sesión"
      redirect_to action: :index
    else
      redirect_to action: :index
    end
  end

public
  def logout_administrador
    if sesion_admin_iniciada
      session[:admin_id] = 0
      flash[:notice] = "Fin de sesión"
      redirect_to action: :index
    else
      redirect_to action: :index
    end
  end

public
  def checkregistro
    mensaje = "No puede crear una cuenta con una sesión abierta"
  if comprobar_sesiones(mensaje1=mensaje, mensaje2=mensaje)
      return
    end

    params.require(:user)
    params.require(:password)
    params.require(:password_repeat)

    if params[:password]==params[:password_repeat]
      usuario = params[:user]
      pass =  params[:password].to_s #to_s es pasarlo a string
      n = User.new
      n.user = usuario
      n.password = pass
      n.save! #la ! sirve para guardar el nuevo usuario.
      flash[:notice] = "Cuenta creada correctamente. Puede ingresar al sistema con su nueva cuenta "+ n.user
      redirect_to action: :login
    else
      flash[:notice] = "Las contraseñas no coinciden, vuelva a intentarlo"
      redirect_to action: :registro
    end
 end

public
def numero
  if sesion_iniciada
    @vista = "usuario"
    @usuario = User.find_by(id: session[:user_id])
    admin = User.find_by(admin: :true)
    if @usuario.numero.nil?
      @numero = nil
      @loteria = admin.numero unless admin.numero.nil?
    else
      @numero = @usuario.numero
      @loteria = admin.numero
    end
  elsif sesion_admin_iniciada
    @vista = "admin"
    @admin = User.find_by(id: session[:admin_id])
    unless @admin.numero.nil?
      @loteria = @admin.numero
    end
  else
    flash[:notice] = "No puede entrar sin haber iniciado la sesión"
    redirect_to action: :index
  end
 end

public
def checknumero
 if sesion_iniciada
    params.require(:numero)
    num = numero_o_nulo(params[:numero])
    if num.nil?
      flash[:notice] = "No es un número válido"
      redirect_to action: :numero
      return
    else
      @usuario = User.find_by(id: session[:user_id])
      @usuario.update(numero: num)
      flash[:notice] = "Su número de Lotería ha sido guardado correctamente"
      redirect_to action: :numero
      return
    end
  elsif sesion_admin_iniciada
    params.require(:numero)
    num = numero_o_nulo(params[:numero])
    if num.nil?
      flash[:notice] = "No es un número válido"
      redirect_to action: :numero
      return
    else
      @admin = User.find_by(id: session[:admin_id])
      @admin.update(numero: num)
      @loteria = num
      flash[:notice] = "Número ganador de Lotería guardado correctamente"
      redirect_to action: :numero
      return 
    end
  end
    flash[:notice] = "No puede acceder"
    redirect_to action: :index
 end

private 
def numero_o_nulo (string)

num = string.to_i

num if num.to_s == string

end

public
def reiniciar_sorteo
  User.update_all(numero: nil)
  flash[:notice] = "Sorteo reiniciado"
  redirect_to action: :index
end

def save_numero
  if sesion_iniciada
    params.require(:numero)
    num = numero_o_nulo(params[:numero])
    if num.nil?
      flash[:notice] = "No es número"
      redirect_to action: :numero
      return
    else
      @usuario = User.find_by(id: session[:user_id])
      @usuario.update(numero: num)
      flash[:notice] = "Su número de Lotería ha sido guardado correctamente"
      redirect_to action: :numero
      return
    end
  elsif sesion_admin_iniciada
    params.require(:numero)
    num = numero_o_nulo(params[:numero])
    if num.nil?
      flash[:notice] = "No es número"
      redirect_to action: :numero
      return
    else
      @admin = User.find_by(id: session[:admin_id])
      @admin.update(numero: num)
      @loteria = num
      flash[:notice] = "Número ganador de Lotería guardado correctamente"
      redirect_to action: :numero
      return 
    end
  end
    flash[:notice] = "No puede acceder"
    redirect_to action: :index
 end



end