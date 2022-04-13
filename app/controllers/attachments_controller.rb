class AttachmentsController < ApplicationController
  def destroy 
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    @attachment.destroy
  end
end
