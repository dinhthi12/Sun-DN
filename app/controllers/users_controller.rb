class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update show)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.order_by_name
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts, items: Settings.digits.length_6
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "notification.check_mail"
      redirect_to root_url
      flash[:success] = t "notification.success"
    else
      flash[:warning] = t "notification.err"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "notification.update"
      redirect_to @user
    else
      flash.now[:warning] = t "notification.not_update"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "notification.destroy"
    else
      flash[:danger] = "notification.not_destroy"
    end
    redirect_to users_path
  end

  def following
    @title = t "users.show_follow.following_title"
    @pagy_users, @users = pagy @user.following.order_by_name
    render :show_follow
  end

  def followers
    @title = t "users.show_follow.followers_title"
    @pagy_users, @users = pagy @user.followers.order_by_name
    render :show_follow
  end

  private

  def correct_user
    return if current_user? @user

    flash[:error] = "notification.not_edit"
    redirect_to root_url
  end

  def action_if_not_logged_in
    store_location
    flash[:danger] = t "notification.request_login"
    redirect_to login_url
  end

  def logged_in_user
    action_if_not_logged_in unless logged_in?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "notification.err"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path
    flash[:danger] = t "notification.not_admin"
  end
end
