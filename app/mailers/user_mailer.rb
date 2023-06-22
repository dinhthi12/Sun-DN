class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user.new.title_account")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("users.edit.mail_reset_password")
  end
end
