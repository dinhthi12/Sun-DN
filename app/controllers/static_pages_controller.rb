class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, items: Settings.digits.length_6
  end

  def help; end
end
