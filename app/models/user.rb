class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :facebook ]

  has_many :questions
  has_many :answers

  def author_of?(resource)
    id == resource.user_id
  end

  def voted?(resource)
    resource.votes.where(user_id: id).any?
  end
end
