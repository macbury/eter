module ApplicationHelper
  def render_flashes
    flash.map do |type, message|
      content_tag "div", message, type: type, "flash" => true
    end.join("\n").html_safe
  end
end
