class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :user_id, :raiting, :best_answer
end
