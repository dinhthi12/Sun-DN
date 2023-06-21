class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email).downcase
    if user&.authenticate params.dig(:session, :password)
      action_check_active user
    else
      flash[:warning] =
        "notification.mail.activation_link"
      redirect_to root_url
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

  def action_check_active user
    if user.activated?
      login_success user
      redirect_back_or user
    else
      flash[:warning] = t "notification.check_activate_mail"
      redirect_to root_url
    end
  end
end
