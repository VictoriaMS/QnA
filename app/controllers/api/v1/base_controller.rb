class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  check_authorization

  protected 

  def current_resourse_owner
    @current_resourse_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end 

  def current_ability
    @ability ||= Ability.new(current_resourse_owner)
  end
end
