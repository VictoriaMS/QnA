class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :destroy ]
  before_action :set_question, only: [ :destroy, :show, :update ]
  before_action :set_questions_list, only: [ :index, :create, :update]

  def index 
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

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def show 
    @answer = @question.answers.new 
  end

  private

  def set_questions_list
    @questions = Question.all
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
