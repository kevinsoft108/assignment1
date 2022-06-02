include UserLogin

class AuthVerificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @email = session[:email]
    render "auth/verify"
  end

  def create
    @email = session[:email]
    resp = UserLogin.verify(@email, params[:auth_code], session[:salt])

    if resp.error
      flash[:error] = resp.error
      render "auth/verify"
    else
      session.delete(:email)
      session.delete(:salt)
      session[:user_id] = resp.user.id
      redirect_to root_path, notice: "You are now signed in"
    end
  end
end