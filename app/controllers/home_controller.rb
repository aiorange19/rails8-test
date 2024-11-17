class HomeController < ApplicationController
  def index
    @current_user = Current.session.user
  end
end
