source 'https://rubygems.org'

gem 'rails', '3.2.12'

group :development do
  gem 'sqlite3'
end 

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'therubyracer', :platforms => :ruby
  gem "less-rails"

  gem 'uglifier', '>= 1.0.3'
end

# Development Stuff
gem 'jazz_hands', :group => [:development, :test]
gem 'simplecov', :require => false, :group => :test # Code Coverage
gem "factory_girl_rails", "~> 4.0"

gem 'localeapp'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-cookie-rails'
gem 'jquery-validation-rails'
gem 'select2-rails'
gem 'twitter-bootstrap-rails'
gem 'rails-i18n'
gem 'validates_email_format_of'
gem 'rails3-jquery-autocomplete'
gem 'mail_form'
gem 'simple_form'
gem 'dynamic_form'
gem 'bootstrap-datepicker-rails'
gem 'geocoder'

# Authentication modules
# NOTE: Temporarily forcing version because of a bug in 1.4.1 with client flow
gem 'omniauth-facebook', "1.4.0"
gem 'omniauth-vkontakte'

# Deployment Stuff
#gem 'foreman'
gem 'unicorn'

