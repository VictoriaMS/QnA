class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, inverse_of: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true 

  validates :body, presence: true

  scope :best_answer, -> { where(best_answer: true) }

  def mark_best!
    update(best_answer: true) 
  end

  def unmark_best!
    update(best_answer: false)
  end
end
