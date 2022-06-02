class Question < ApplicationRecord
  include Votable

  has_many :comments, as: :commentable
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, inverse_of: :attachable
  has_many :question_subscribes, dependent: :destroy

  belongs_to :user
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true 
  validates :title, :body, presence: true

  after_create :subscribe_for_question

  def subscribe_for_question
    QuestionSubscribe.create!(question_id: id, user_id: user.id)
  end 
end
