class LoteriaController < ApplicationController
  def index
  	if logueado
  		@sesion_iniciada = true

  		@u = User.where(id: session[:id_usuario]).first
  	else
  	 	@sesion_iniciada = false
  	end
  end

  private 
  def logueado
  	if session[:id_usuario].nil? 
  		return false
  	elsif session[:id_usuario] == 0
  		return false
  	else
  		return true
  	end
  end
end
