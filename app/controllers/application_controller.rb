class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  helper_method :current_user

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    redirect_to cats_url
  end

  def logout!
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    return nil unless session[:session_token]
    User.find_by(session_token: session[:session_token])
  end

  def require_logged_out
    redirect_to cats_url if logged_in?
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_owns_cat
    c = current_user.cats.find_by(id: params[:id])
    redirect_to cats_url if c.nil?
  end
end
