class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :commentable_id, :commentable_type, :created_at, :updated_at, :user_id
end
