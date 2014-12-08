require "templates_paths"
module JsEnv
  extend ActiveSupport::Concern
  include TemplatesPaths

  included do
    helper_method :js_env
  end

  def apply_timestamp(asset_path)
    if Rails.env == "development"
      asset_path + "?t=#{@timestamp}"
    else
      asset_path
    end
  end

  def js_env
    @timestamp     = Rails.application.assets.digest
    all_templates = templates.inject({}) { |out, paths|
      out[paths[0]] = apply_timestamp(paths[1])
      out
    }
    data = {
      env: Rails.env,
      templates: all_templates,
      locale: {
        default: I18n.default_locale,
        locale: I18n.locale
      }
    }
  end

  def js_env_etag
    Rails.application.assets.digest.to_s
  end
end
