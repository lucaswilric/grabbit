class ApplicationController < ActionController::Base
  include UserHolderController
  
  protect_from_forgery
  before_filter :get_user
end
