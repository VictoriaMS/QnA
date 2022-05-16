class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :facebook, :twitter ]

  has_many :questions
  has_many :answers
  has_many :authorizations

  def author_of?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    resource.votes.where(user_id: id).any?
  end

  def self.find_for_oauth(session)
    authorization = Authorization.where(provider: session[:provider], uid: session[:uid].to_s).first
    return authorization.user if authorization
    
    email = session[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization(session)
    else 
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password )
      user.create_authorization(session)
    end
    user
  end

  def self.find_by_auth(provider, uid)
    joins(:authorizations).where(authorizations: { provider: provider, uid: uid.to_s }).first
  end

  def create_authorization(session)
    authorizations.create(provider: session[:provider], uid: session[:uid].to_s)
  end
end
