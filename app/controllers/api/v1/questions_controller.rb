class Api::V1::QuestionsController < Api::V1::BaseController
  def index 
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionsSerializer
  end

  def show 
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionSerializer
  end

  def create
    @question = Question.create(question_params)
    respond_with @question, serializer: QuestionSerializer
  end

  private 

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end 
