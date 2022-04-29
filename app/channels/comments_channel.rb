class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['question']['id']}_comments"
  end
end
