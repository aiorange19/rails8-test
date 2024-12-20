class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      if user.confirmed?
        start_new_session_for user
        redirect_to after_authentication_url
      else
        flash[:alert] = 'メールアドレス認証を行ってください。'
        render :new
      end
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session # ApplicationControllerでinclude Authenticationされている
    redirect_to new_session_path
  end
end
