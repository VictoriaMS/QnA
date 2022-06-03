class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: %i[new create destroy ]
  before_action :set_question, only: %i[destroy show update publish_question save_question  ]
  before_action :set_questions_list, only: %i[index create update]
  before_action :create_answer, only: :show
  before_action :save_user, only: :show
  before_action :save_question, only: :show
  before_action :set_subscribe, only: :show

  after_action :publish_question, only: [:create ]

  authorize_resource

  respond_to :js, only: :update

  def index 
    respond_with @questions
  end 

  def new
    respond_with(@question = Question.new)
  end

  def create 
    respond_with(@question = current_user.questions.create(question_params))
  end 

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  def show
    respond_with @question
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
      QuestionSerializer.new(@question).to_json
    )
  end

  def set_subscribe 
    @subscribe = @question.question_subscribes.find_by(user_id: current_user.id) if current_user
  end

  def create_answer
    @answer = @question.answers.new
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
