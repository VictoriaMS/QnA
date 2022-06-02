class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer.subject
  #
  def new_answer(answer)
    @greeting = "Hi"
    @answer = answer

    mail to: @answer.question.user.email
  end
end
