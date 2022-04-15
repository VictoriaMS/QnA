class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :destroy ]
  before_action :set_question, only: [ :destroy, :show, :update, :update_voted_down, :update_voted_up ]
  before_action :set_questions_list, only: [ :index, :create, :update]

  def index 
  end 

  def new
    @question = Question.new
    @question.attachments.build
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
    @questions = Question.all
    @question.destroy
  end

  def show 
    @answer = @question.answers.new 
    @answer.attachments.build
  end

  def update_voted_up
    vote(@question, 'up')
  end

  def update_voted_down
    vote(@question, 'down')
  end

  private

  def set_questions_list
    @questions = Question.all
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
