class User < ApplicationRecord
  EMAIL_CONFIRMATION_LIMIT = 5.minutes # 実案件では各案件ルールに従った定数の設定が良い

  before_create :generate_confirmation_token

  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :confirmation_status, { confirmed: 0, unconfirmed: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def confirm!
    update!(
      confirmation_status: :confirmed,
      confirmation_token: nil,
      expiration_date: nil
    )
  end

  # expiration_date が存在する場合：
  #   expiration_dateが現在時刻より前なら true（期限切れ）
  #   expiration_dateが現在時刻より後なら false（有効）
  # expiration_date が nil の場合：
  # false を返す（期限切れではない）
  def expired?
    expiration_date.present? ? expiration_date < Time.zone.now : false
  end

  private

  # トークンとトークン期限の設定
  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(47)
    self.expiration_date = Time.zone.now + EMAIL_CONFIRMATION_LIMIT
  end
end
