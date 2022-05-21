class Api::V1::ProfilesController  < ApplicationController 
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resourse_owner
  end

  protected 

  def current_resourse_owner
    @current_resourse_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end 
end
