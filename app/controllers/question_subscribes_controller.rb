class QuestionSubscribesController < ApplicationController
  before_action :set_question, only: :create

  def create
    unless current_user.have_subscribe?(@question)
      current_user.question_subscribes.create!(question: @question)
      flash[:notice] = 'You subscribed to notifications of new answers for this question'
    end

    redirect_to @question
  end

  def destroy 
    @subscribe = QuestionSubscribe.find(params[:id])
    @subscribe.destroy
    flash[:notice] = 'You unsubscribed from the question'
    redirect_to @subscribe.question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
