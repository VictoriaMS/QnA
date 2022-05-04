class CommentsController < ApplicationController
  before_action :set_comment, only: :save_user
  before_action :set_resource, only: :create
  after_action :publish_comment, only: :create

  respond_to :json, only: :create

  def create 
    respond_with (@comment = @resource.comments.create(comment_params.merge(user: current_user)))
  end

  private 

  def publish_comment
    if @comment.commentable_type == 'Question'
      return if @comment.errors.any?
      ActionCable.server.broadcast(
      "question_#{@comment.commentable_id}_comments",
      ApplicationController.render(json: @comment ))
    end
  end

  def set_resource 
    klass = [Question, Answer].detect { |klass| params["#{klass.name.underscore}_id"] }
    @resource = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
