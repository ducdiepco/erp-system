require 'dry/system/container'
require_relative 'resolver'

class Container < Dry::System::Container
  extend Dry::Hanami::Resolver

  register_folder! 'coreapp/repositories'


  namespace('payment_api') do
    register_folder_in_app! 'payment_api/commands'
    namespace('services') do
      register('merchant') { load! 'payment_api/merchants/action' }
    end
  end
  register_folder! 'payment_api/matchers', resolver: ->(k) { k::Matcher }

  configure
end
