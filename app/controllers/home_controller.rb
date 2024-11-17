class HomeController < ApplicationController
  def index
    @current_user = Current.user
  end
end
