class AttachmentsController < ApplicationController
  before_action :set_attachment, only: :destroy

  respond_to :js, only: :destroy

  def destroy 
    respond_with(@attachment.destroy)
  end

  private 

  def set_attachment 
    @attachment = Attachment.find(params[:id])
  end
end
