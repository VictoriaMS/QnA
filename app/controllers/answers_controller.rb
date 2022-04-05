class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[ new create destroy]
  before_action :set_question, only: %i[new create destroy update]
  before_action :set_answer, only: %i[ destroy update ]


  def new 
    @answer = @question.answers.new
  end

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy  
    redirect_to question_path(@question)
  end

  def update 
    @answers = @question.answers
    @answer.update(answer_params)
  end

  private 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question 
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
