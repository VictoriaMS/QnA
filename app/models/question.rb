class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, inverse_of: :attachable
  has_many :votes, as: :votable, inverse_of: :votable

  belongs_to :user
  
  accepts_nested_attributes_for :votes
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true 
  validates :title, :body, presence: true
end
