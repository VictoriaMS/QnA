class AnswersController < ApplicationController
  def new 
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new
  end

  def create 
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to question_answer_path(@answer, @question)
    else 
      render :new 
    end
  end

  private 

  def answer_params
    params.require(:answer).permit(:body)
  end
end
