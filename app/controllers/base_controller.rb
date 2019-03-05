class BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'app'

  def index
    @title = 'Heloo'
  end
end
