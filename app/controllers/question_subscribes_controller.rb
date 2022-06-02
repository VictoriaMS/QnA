class QuestionSubscribesController < ApplicationController
  before_action :set_question

  def create
    if current_user.have_subscribe?(@question)
      flash[:alert] = 'You are already subscribed to this question'
    else
      current_user.question_subscribes.create!(question: @question)
      flash[:notice] = 'You subscribed to notifications of new answers for this question'
    end

    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
