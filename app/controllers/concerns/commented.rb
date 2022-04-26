module Commented
  extend ActiveSupport::Concern

  def add_comment
    @comment = @object.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    respond_to { |format| format.json { render json: @comment } }
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end 
end
