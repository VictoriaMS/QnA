module Commentable
  extend ActiveSupport::Concern
  
  included do 
    has_many :comments, as: :commentable
  end 

  def add_comment(user, body)
    @comment = comments.build(body)
    @comment.user = user
    @comment.save
  end
end
