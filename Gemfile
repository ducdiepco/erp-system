source 'https://rubygems.org'

gem 'rake'

gem 'hanami-utils',       require: false, git: 'https://github.com/hanami/utils.git',       branch: 'develop'
gem 'hanami-validations', require: false, git: 'https://github.com/hanami/validations.git', branch: 'develop'
gem 'hanami-router',      require: false, git: 'https://github.com/hanami/router.git',      branch: 'develop'
gem 'hanami-controller',  require: false, git: 'https://github.com/hanami/controller.git',  branch: 'develop'
gem 'hanami-view',        require: false, git: 'https://github.com/hanami/view.git',        branch: 'develop'
gem 'hanami-helpers',     require: false, git: 'https://github.com/hanami/helpers.git',     branch: 'develop'
gem 'hanami-mailer',      require: false, git: 'https://github.com/hanami/mailer.git',      branch: 'develop'
gem 'hanami-cli',         require: false, git: 'https://github.com/hanami/cli.git',         branch: 'develop'
gem 'hanami-assets',      require: false, git: 'https://github.com/hanami/assets.git',      branch: 'develop'
gem 'hanami-model',       require: false, git: 'https://github.com/hanami/model.git',       branch: 'develop'
gem 'hanami',                             git: 'https://github.com/hanami/hanami.git',      branch: 'develop'

gem 'pg'

gem 'haml'
gem 'dry-matcher'
gem 'dry-monads'
gem 'dry-system'
gem 'dry-initializer'
gem 'curb'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
  ### Debugger ###
  gem 'byebug' # fix call in action#call
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'database_cleaner'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rspec-hanami'
  gem 'webmock'
  gem 'vcr'
  gem 'hanami-fabrication'
  gem 'faker'
end

group :production do
  # gem 'puma'
end
