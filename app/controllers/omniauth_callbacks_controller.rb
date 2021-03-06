class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth, only: [:facebook, :twitter]
  before_action -> { authenticate(@auth) }, only: [:facebook, :twitter]

  def facebook 
  end

  def twitter 
  end

  def set_email 
    if params[:email].present?
      session[:email] = params[:email]
      authenticate_user(session)
    else
      render :email_request
    end
  end

  private 

  def set_auth
    @auth = request.env['omniauth.auth']
  end

  def authenticate_user(session)
    @user = User.find_for_oauth(session)
    if @user.persisted? && @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: session[:provider]) if is_navigational_format?     
    else
      redirect_to root_path
      set_flash_message(:notice, :failure, kind: session[:provider], reason: 'You need to confirm email') if is_navigational_format?
    end
  end

  def authenticate(auth)
    session[:provider] = auth.provider 
    session[:uid] = auth.uid 
    session[:email] = auth.info[:email]

    if session[:email].blank?
      check_user(session)
    else 
      authenticate_user(session)
    end
  end

  def check_user(session)
    user = User.find_by_auth(session[:provider], session[:uid])
    if user 
      authenticate_user(session)
    else 
      render :email_request
    end
  end
end
