class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :show]
  authorize_resource
  
  def index 
    respond_with @question.answers, each_serializer: AnswersSerializer
  end

  def show
    respond_with Answer.find(params[:id]), serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.create(answer_params)
    respond_with @answer, serializer: AnswerSerializer
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
