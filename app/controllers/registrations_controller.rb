class RegistrationsController < ApplicationController
  allow_unauthenticated_access # 認証前にアクセス可能に

  def new
  end

  def create
    @user = User.new(params.permit(:email_address, :password))
    if @user.save
      UserMailer.send_email_confirmation(@user).deliver_later
      redirect_to root_path, notice: '登録したメールアドレスに確認メールを送信しました。'
    else
      flash.now[:alert] = "Failed to sign up"
      render :new
    end
  end

  # メール認証用アクション
  def confirm_email
    @user = User.find_by(confirmation_token: params[:token])

    # 未確認状態かつトークン有効期間内
    if @user.unconfirmed? && !@user.expired?
      @user.confirm!
      redirect_to root_path, notice: "メールアドレスの確認が完了しました"
    else
      redirect_to root_path, alert: "無効なトークンです"
    end
  end
end