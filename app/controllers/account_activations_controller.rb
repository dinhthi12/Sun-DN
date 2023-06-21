class AccountActivationsController < ApplicationController
  before_action :load_user_account, only: :edit
  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = "account.activated"
      redirect_to @user
    else
      flash[:danger] = "account.invalid_activate"
      redirect_to root_url
    end
  end

  private
  def load_user_account
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = "users.new.err"
    redirect_to root_path
  end
end
