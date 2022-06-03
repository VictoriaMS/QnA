class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    @questions_for_today = Question.where('created_at >= ? AND created_at < ?', Time.current.beginning_of_day,
                                                                                Time.current.beginning_of_day + 1.day)
    mail to: user.email 
  end
end
