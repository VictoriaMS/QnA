class Api::V1::AnswersController < Api::V1::BaseController
  def index 
    question = Question.find(params[:question_id])
    @answers = question.answers
    respond_with @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: AnswerSerializer
  end

  def create
    question = Question.find(params[:question_id])
    @answer = question.answers.create(answer_params)
    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
