class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  helper_method :current_user

  def login

  end

  def logout
  end

  def current_user
    puts "session token is " + session[:session_token].to_s
    return nil unless session[:session_token]
    User.find_by(session_token: session[:session_token])
  end

  def require_logged_out
  end

  def require_logged_in
  end

end
