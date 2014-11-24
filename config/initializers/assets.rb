# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '0.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w{locales/*.json templates/*.slim}
Rails.application.assets.register_mime_type 'text/html', '.html'
Rails.application.assets.register_engine '.slim', Slim::Template

class Sprockets::DirectiveProcessor
  def process_depend_on_config_directive(file)
    path = File.expand_path(file, Rails.root.join('config'))
    context.depend_on(path)
  end
end

# register .json for assets pipeline
Rails.application.assets.register_mime_type 'application/json', '.json'
# enable to use sprockets directive processor in .json
Rails.application.assets.register_preprocessor 'application/json', Sprockets::DirectiveProcessor
