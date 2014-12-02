require "templates_paths"
module JsEnv
  extend ActiveSupport::Concern
  include TemplatesPaths

  included do
    helper_method :js_env
  end

  def js_env
    data = {
      env: Rails.env,
      templates: templates,
      locale: {
        default: I18n.default_locale,
        locale: I18n.locale
      }
    }
  end

  def js_env_etag
    Digest::SHA256.hexdigest(js_env.to_json)
  end
end
