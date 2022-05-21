class Api::V1::ProfilesController  < ApplicationController 
  before_action :doorkeeper_authorize!
  before_action :current_resourse_owner, only: [:me, :index]

  respond_to :json

  def me
    respond_with @current_resourse_owner
  end

  def index
    @users = User.where.not(id: @current_resourse_owner.id)
    respond_with @users
  end

  protected 

  def current_resourse_owner
    @current_resourse_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end 
end
