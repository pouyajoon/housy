class HousyController < ActionController::Base
  before_action :authenticate_admin_user!, :unless => :devise_controller?
end
