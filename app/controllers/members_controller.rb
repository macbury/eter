class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.by_query(params.require(:term))
    render json: @user.map { |user| { id: user.id, label: user.full_info } }
  end
end
