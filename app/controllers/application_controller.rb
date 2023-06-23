class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper
  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.request_login"
    redirect_to login_path
  end
end
