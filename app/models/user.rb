class User < ApplicationRecord

  before_create :generate_auth_secret

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  def self.generate_auth_salt
    ROTP::Base32.random(16)
  end

  def auth_code(salt)
    totp(salt).now
  end

  def valid_auth_code?(salt, code)
    # 15mins validity
    totp(salt).verify(code, drift_behind: 9000).present?
  end

  private

  # This is used as a secret for this user to 
  # generate their OTPs, keep it private.
  def generate_auth_secret
    self.auth_secret = ROTP::Base32.random(16)
  end

  def totp(salt)
    ROTP::TOTP.new(auth_secret + salt, issuer: "YourAppName")
  end
end
