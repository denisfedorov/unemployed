class SessionsController < ApplicationController

  def new
  end

  def create
    if !env['omniauth.auth'] 
      user = User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_back_or user
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new'
      end
    else
      user = User.from_omniauth(env["omniauth.auth"])
      sign_in user
      redirect_back_or root_url
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end