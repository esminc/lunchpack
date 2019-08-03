class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :trackable, :omniauthable, omniauth_providers: %i(google)

  protected
  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.create(email:     auth.info.email,
                          provider: auth.provider,
                          uid:      auth.uid,
                          token:    auth.credentials.token,
                          password: Devise.friendly_token[0, 20],
                          meta:     auth.to_yaml)
    end
    user
  end
end
