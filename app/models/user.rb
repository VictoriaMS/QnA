class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :facebook ]

  has_many :questions
  has_many :answers
  has_many :authorizations

  def author_of?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    resource.votes.where(user_id: id).any?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    
    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization(auth)
    else 
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password )
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
