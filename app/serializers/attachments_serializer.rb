class AttachmentsSerializer < ActiveModel::Serializer
  attribute :url 

  def url 
    object.file.url
  end
end
