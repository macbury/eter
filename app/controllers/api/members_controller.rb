class Api::MembersController < ApiController

  def show
    @user = User.by_query(params.require(:term))
    render json: @user.map { |user| { id: user.id, label: user.full_info } }
  end
end
