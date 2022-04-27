class Question < ApplicationRecord
  include Votable

  has_many :comments, as: :commentable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, inverse_of: :attachable

  belongs_to :user
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true 
  validates :title, :body, presence: true
end
