source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails', '4.1.8'
gem 'mysql2'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby

gem "transitions", :require => ["transitions", "active_model/transitions"]
gem "color-generator"
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

gem 'unicorn'
gem "unicorn-rails"

gem "faye", require: false

group :auth do
  gem "devise"
  gem 'devise_invitable', '~> 1.3.4'
  gem "cancan"
end

gem "figaro"
gem "slim-rails"
gem "simple_form", ">= 3.1.0.rc1"


group :assets do
  gem 'bootstrap-sass', '~> 3.3.1'
  gem 'autoprefixer-rails'

  gem 'font-awesome-sass', '~> 4.2.0'
  gem 'haml_coffee_assets'
  gem "quiet_assets"

  gem 'angularjs-rails'
  gem 'rails-assets-angular-translate'
  gem 'rails-assets-angular-loading-bar'
  gem 'rails-assets-angular-spinkit'
  gem "rails-assets-angular-mocks"
  gem 'rails-assets-angular-local-storage'
  gem 'jquery-ui-rails'
end

group :api do
  gem 'gitlab'
end

group :development, :test do
  gem "guard"
  gem "capybara"
  gem 'poltergeist'
  gem "database_cleaner"
  gem "guard-rspec"
  gem 'guard-livereload'
  gem "guard-bundler"
  gem 'guard-rails'
  gem 'pry-rails'
  gem "rspec-rails"
  gem 'factory_girl_rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'shoulda-matchers', require: false
  gem "rack-livereload"
  gem "launchy"
  gem "faker"
  gem 'puffing-billy', require: false
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
