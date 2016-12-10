class HomeController < ApplicationController
  def index
  end

  # GET /auth/:provider/callback?id_token=xxx
  def callback
    session[:auth] = auth_hash
    redirect_to '/'
  end

  def signout
    session[:auth] = nil
    redirect_to '/'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
