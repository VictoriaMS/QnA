class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[ new create destroy]
  before_action :set_question, only: %i[new create destroy update update_best_answer]
  before_action :set_answer, only: %i[ destroy update update_best_answer update_voted_down update_voted_up]
  before_action :set_answers_list, only: %i[ destroy update ]


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
    if @question.answers.best_answer.empty?
      @answer.mark_best!
      redirect_to question_path(@question)
    else 
      @question.answers.best_answer.first.unmark_best!
      @answer.mark_best!
      redirect_to question_path(@question)
    end
  end

  def update_voted_up
    unless current_user.author_of?(@answer)
      @answer.vote_up!
      respond_to do |format|
        format.json { render json: @answer }
      end
    end
  end

  def update_voted_down
    unless current_user.author_of?(@answer)
      @answer.vote_down!
      respond_to do |format|
        format.json { render json: @answer }
      end
    end
  end

  private 

  def set_answers_list
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
