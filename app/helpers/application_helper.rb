module ApplicationHelper
  def render_flashes
    flash.map do |type, message|
      content_tag "div", message, type: type, "flash" => true
    end.join("\n").html_safe
  end

  def env_tag
    tag :meta, name: "rails", content: js_env.to_json
  end
end
