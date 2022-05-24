class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :user_id, :raiting

  has_many :comments, serializer: CommentSerializer
  has_many :attachments, each_serializer: AttachmentsSerializer
end
