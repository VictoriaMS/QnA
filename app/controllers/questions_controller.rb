class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :destroy ]
  before_action :set_question, only: [ :destroy, :show]

  def index 
    @questions = Question.all
  end 

  def new
    @question = Question.new
  end

  def create 
    @question = current_user.questions.new(question_params)
    
    if @question.save
      redirect_to @question, notice: 'Your question successfully created' 
    else
      render :new
    end
  end 

  def destroy
    if current_user == @question.user
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted' 
    else 
      redirect_to questions_path, notice: 'You cannot delete this question.' 
    end
  end

  def show 
    @answer = @question.answers.new
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
