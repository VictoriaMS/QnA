class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, only: %i[ new create destroy]
  before_action :set_question, only: %i[new create save_question publish_answer]
  before_action :set_answer, only: %i[ destroy update update_best_answer publish_answer]
  before_action :set_answers_list, only: %i[ destroy update ]
  before_action :save_user, only: %i[ create ]
  before_action :set_object, only: %i[voted_up voted_down revote] 

  after_action :publish_answer, only: [:create]

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
  end

  def update  
    @answer.update(answer_params)
  end

  def update_best_answer
    if @answer.question.answers.best_answer.empty?
      @answer.mark_best!
      redirect_to question_path(@answer.question)
    else 
      @answer.question.answers.best_answer.first.unmark_best!
      @answer.mark_best!
      redirect_to question_path(@answer.question)
    end
  end

  private 
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
