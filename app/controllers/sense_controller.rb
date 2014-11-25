class SenseController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create
    @context = SenseContext.new(params, current_user)
    render json: []
  end
end
