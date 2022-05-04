class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, only: %i[ new create destroy]
  before_action :set_question, only: %i[new create save_question publish_answer]
  before_action :set_answer, only: %i[ destroy update update_best_answer publish_answer]
  before_action :set_answers_list, only: %i[ destroy update ]
  before_action :save_user, only: %i[ create ]
  before_action :set_object, only: %i[voted_up voted_down revote] 
  before_action :set_best_answer, only: :update_best_answer

  after_action :publish_answer, only: [:create]
  
  respond_to :js, only: %i[create destroy update]

  def new 
    respond_with(@answer = @question.answers.new)
  end

  def create 
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)  
  end

  def update  
    @answer.update(answer_params)
    respond_with @answer
  end

  def update_best_answer
    respond_with @answer,  location: -> { question_path(@answer.question) }
  end

  private 

  def set_best_answer
    if @answer.question.answers.best_answer.empty?
      @answer.mark_best!
    else 
      @answer.re_mark_best!
    end
  end
  
  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers_for_question_#{@question.id}",
    ApplicationController.render(json: @answer))
  end

  def save_user
    gon.user = current_user if current_user
  end

  def set_answers_list
    @question = @answer.question
    @answers = @question.answers
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question 
    @question = Question.find(params[:question_id]) 
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
