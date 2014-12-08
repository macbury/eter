class Api::AngularController < ApplicationController
  include JsEnv

  def show
    if stale?(etag: js_env_etag)
      render json: js_env
    end
  end

end
