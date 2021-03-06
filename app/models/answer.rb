class Answer < ApplicationRecord
  include Votable
  belongs_to :question, touch: true
  belongs_to :user

  has_many :comments, as: :commentable
  has_many :attachments, as: :attachable, inverse_of: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true 

  validates :body, presence: true

  scope :best_answer, -> { where(best_answer: true) }

  after_create :send_notification

  def mark_best!
    update(best_answer: true) 
  end

  def unmark_best!
    update(best_answer: false)
  end

  def re_mark_best!
    question.answers.best_answer.first.unmark_best!
    self.mark_best!
  end

  private 

  def send_notification
    question.question_subscribes.each do |subscribe|
      NotificationMailer.for_subscribers(subscribe.user, self).deliver_later
    end
  end
end
