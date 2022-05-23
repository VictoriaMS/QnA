class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :current_resourse_owner

  respond_to :json

  protected 

  def current_resourse_owner
    @current_resourse_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end 
end
