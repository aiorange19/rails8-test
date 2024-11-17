class UserMailer < ApplicationMailer
  def send_email_confirmation(user)
    @user = user
    mail subject: "メールアドレス認証のお願い", to: user.email_address
  end
end
