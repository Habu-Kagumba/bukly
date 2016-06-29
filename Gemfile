source "https://rubygems.org"

ruby "2.3.0"

gem "active_model_serializers"
gem "ffaker"
gem "figaro"
gem "oj"
gem "oj_mimic_json"
gem "pg"
gem "puma"
gem "rails", "4.2.6"
gem "rails-api"

group :development, :test do
  gem "brakeman", require: false
  gem "coveralls", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "guard", require: false
  gem "guard-rspec", require: false
  gem "json-schema"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rubycritic", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "spring"
end

group :production do
  gem "rails_12factor"
end
