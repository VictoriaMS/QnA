class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :raiting

  has_many :comments
  has_many :attachments, serializer: AttachmentsSerializer
  has_many :answers
end
