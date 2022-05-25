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
end
