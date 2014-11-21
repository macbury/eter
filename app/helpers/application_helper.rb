module ApplicationHelper
  def render_flashes
    content_tag "flash-alert", flash.map { |k,v| v }.join(", "), { data: { messages: flash.inject({}) { |out, msg| out[msg[0]] = msg[1]; out }  } }
  end
end
