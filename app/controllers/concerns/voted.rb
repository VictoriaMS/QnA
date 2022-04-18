module Voted 
  extend ActiveSupport::Concern

  included do 
    before_action :set_object, only: [:voted_up, :voted_down] 
  end

  def voted_up 
    @object.vote_up(current_user)
    respond_to do |format|
      format.json { render json: @object }  
    end
  end

  def voted_down
    @object.vote_down(current_user)
    respond_to do |format|
      format.json { render json: @object }
    end
  end

  private 

  def set_object
    @object = klass.find(params[:id])
  end

  def klass
    controller_name.classify.constantize
  end
end
