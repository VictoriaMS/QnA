class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: [ :new, :create, :destroy ]
  before_action :set_question, only: [ :destroy, :show, :update, :publish_question, :save_question  ]
  before_action :set_questions_list, only: [ :index, :create, :update]
  before_action :save_user, only: [:show]
  before_action :save_question, only: [:show]

  after_action :save_user, only: [ :show ]
  after_action :publish_question, only: [:create ]

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
    redirect_to questions_path
  end

  def show 
    @answer = @question.answers.new 
    @answer.attachments.build
  end

  private

  def save_question
    gon.question = @question 
  end

  def save_user
    gon.user = current_user if current_user
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render( json: @question)
    )
  end

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
