class ApiController < ActionController::Base
  before_action :authenticate_user!
  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.to_s }, status: 403
  end
end
