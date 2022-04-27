class CommentsController < ApplicationController

  def create 
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.save
    respond_to { |format| format.json { render json: @comment } }
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end
