class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :user_id, :raiting, :best_answer

  has_many :comments, serializer: CommentSerializer
  has_many :attachments, serializer: AttachmentsSerializer
end
