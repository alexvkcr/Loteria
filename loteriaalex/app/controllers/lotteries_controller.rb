class LotteriesController < ApplicationController
  def index
  	if session[:user_id].nil?
  		@usuario = nil
  	else
  		@usuario = Loteries.find(session[:user_id])
  	end
  end
  def login
  	if not session[:user_id].nil?
  		render index
  	end
  end
  def check_login
  	
  end
end
