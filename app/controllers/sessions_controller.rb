class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email).downcase
    if user&.authenticate params.dig(:session, :password)
      login_success user
      redirect_back_or user
    else
      flash.now[:danger] = t "users.new.failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    flash[:success] = t "notification.success"
  end
end
