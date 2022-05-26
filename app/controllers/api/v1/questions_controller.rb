class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  
  def index 
    respond_with Question.all, each_serializer: QuestionsSerializer
  end

  def show 
    respond_with Question.find(params[:id]), serializer: QuestionSerializer
  end

  def create
    @question = Question.create(question_params.merge(user: current_resourse_owner ))
    respond_with @question, serializer: QuestionSerializer
  end

  private 

  def question_params
    params.require(:question).permit(:title, :body)
  end
end 
