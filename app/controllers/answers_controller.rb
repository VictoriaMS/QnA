class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[ new create destroy]
  before_action :set_question, only: %i[new create destroy]


  def new 
    @answer = @question.answers.new
  end

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy  
      redirect_to question_path(@question), notice: 'Answer successfully deleted'
    else 
      redirect_to question_path(@question), notice: 'You cannot delete this answer'
    end
  end

  private 

  def set_question 
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
