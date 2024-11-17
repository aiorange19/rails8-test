class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true

  private

  def resume_session
    Current.session = find_session_by_cookie
  end
end
