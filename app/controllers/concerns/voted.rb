module Voted 
  extend ActiveSupport::Concern

  included do 
    before_action :set_object, only: [:voted_up, :voted_down] 
  end

  def voted_up 
    voted('vote_up')
  end

  def voted_down
    voted('vote_down')
  end

  private 

  def voted(option)
    if current_user.voted?(@object)
      respond_to { |format| format.json { render json: t('vote_errors', resource: @object.class.to_s.downcase), status: :unprocessable_entity } }
    else
      @object.send(option, current_user)
      respond_to { |format| format.json { render json: @object } }    
    end 
  end

  def set_object
    @object = klass.find(params[:id])
  end

  def klass
    controller_name.classify.constantize
  end
end
