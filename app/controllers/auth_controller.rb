include UserLogin

class AuthController < ApplicationController
  skip_before_action :authenticate_user!, except: :destroy

  def show; end

  def create
    session[:email] = params[:email]
    session[:salt] = UserLogin.start_auth(params.permit(:email, :first_name, :last_name))
    redirect_to auth_verifications_path
  rescue ActiveRecord::RecordInvalid
    # If the user creations fails (usually when first and last name are empty)
    # we reload the form, and also display the first and last name fields.
    @display_name_fields = false
    render :show
  end

  def destroy
    session.delete(:user_id)
    redirect_to auth_path, notice: "You are signed out"
  end
end