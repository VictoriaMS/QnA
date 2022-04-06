class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_answer, -> { where(best_answer: true) }

  def mark_best!
    self.update(best_answer: true) 
  end
end
