class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "message.micropost.create"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed.newest,
                                items: Settings.digits.length_6
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy!
    flash[:success] = t "message.success.micropost_deleted"
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = t "message.danger.micropost_deleted_unsuccessful"
  ensure
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "message.danger.uncorrect_user"
    redirect_to request.referer || root_url
  end
end
