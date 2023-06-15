class UsersController < ApplicationController
  def index
    @user = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    redirect_to root_path if @user.nil?
    flash[:warning] = t "notification.notfound"
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "notification.success"
      redirect_to @user
    else
      flash[:warning] = t "notification.err"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end
end
