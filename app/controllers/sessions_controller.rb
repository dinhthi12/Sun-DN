class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = t "users.error.str_error"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
