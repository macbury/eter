class SenseController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create
    @context = SenseContext.new(params.require(:sense), current_user, current_ability)
    @context.search
    render json: @context.to_h
  end
end
