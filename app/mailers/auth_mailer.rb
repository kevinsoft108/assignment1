class AuthMailer < ApplicationMailer
  def auth_code(user, auth_code)
    @user = user
    @auth_code = auth_code

    mail to: @user.email, subject: "Hey #{@user.first_name}, use this auth code to sign in"
  end
end