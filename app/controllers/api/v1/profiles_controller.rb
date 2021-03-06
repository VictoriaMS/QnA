class Api::V1::ProfilesController  < Api::V1::BaseController 
  skip_authorization_check 

  def me
    respond_with current_resourse_owner
  end

  def index
    return if current_resourse_owner.nil?
    users = User.where.not(id: current_resourse_owner.id)
    respond_with users
  end
end
