class SenseController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create
    render json: []
  end
end
