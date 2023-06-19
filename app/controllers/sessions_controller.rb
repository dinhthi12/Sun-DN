class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email).downcase
    if user&.authenticate params.dig(:session, :password)
      login_success user
    else
      flash.now[:danger] = t "users.new.failed"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private
  def login_success user
    log_in user
    redirect_to current_user
    flash[:success] = t "notice.success"
  end
end
