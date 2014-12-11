module ResponseMacros

  def expect_to_redirect_to_login
    expect(response).to redirect_to(new_user_session_path)
  end

  def response_json
    JSON.parse(response.body)
  end

end
