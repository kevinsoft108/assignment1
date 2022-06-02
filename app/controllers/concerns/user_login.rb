module UserLogin
  module_function

  # Called when a user first types their email address
  # requesting to login or sign up.
  def start_auth(params)
    # Generate the salt for this login, it will later 
    # be stored in rails session.
    salt = User.generate_auth_salt
    user = User.find_by(email: params.fetch(:email).downcase.strip)
    if user.nil?
      # User is registering a new account
      user = User.create!(params)
    end

    # Email the user their 6 digit code
    AuthMailer.auth_code(user, user.auth_code(salt)).deliver_now

    salt
  end

  # Called to check the code the user types
  # in and make sure it’s valid.
  def verify(email, auth_code, salt)
    user = User.find_by(email: email)

    if user.blank?
      return UserLoginResponse.new(
        "Oh dear, we could not find an account using that email.
        Contact support@nine.shopping if this issue persists."
      )
    end

    unless user.valid_auth_code?(salt, auth_code)
      return UserLoginResponse.new("That code’s not right, better luck next time 😬")
    end

    UserLoginResponse.new(nil, user)
  end

  UserLoginResponse = Struct.new(:error, :user)
end