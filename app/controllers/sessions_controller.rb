class SessionsController < ApplicationController

  before_action :require_logged_out, only: [:new, :create]
  before_action :require_logged_in, only: [:destroy]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if user
      login_user!(user)
    else
      if flash.now[:errors]
        flash.now[:errors] << "Invalid credentials"
      else
        flash.now[:errors] = ["Invalid credentials"]
      end

      render :new
    end
  end

  def destroy
    logout!
  end
end
