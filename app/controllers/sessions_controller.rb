class SessionsController < ApplicationController
  before_action :redirect_to_cats, only: [:new]

  def new
    render :new
  end

  def create
    @current_user = User.find_by_credentials(params[:session][:user_name], params[:session][:password])
    if @current_user
      login_user!(@current_user)
    else
      flash.now[:errors] = 'Password is incorrect for user name'
      render :new
    end

  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
    end
    render :new
  end
end
