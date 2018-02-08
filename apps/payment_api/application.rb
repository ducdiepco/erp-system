require 'hanami/helpers'
require 'hanami/assets'

module PaymentApi
  class Application < Hanami::Application
    configure do
      root __dir__

      default_response_format :json

      load_paths << [
        'controllers',
        'views',
        'commands'
      ]
      routes 'config/routes'

      layout :application # It will load PaymentApi::Views::ApplicationLayout
      templates 'templates'
      assets do
        javascript_compressor :builtin

        stylesheet_compressor :builtin

        # Specify sources for assets
        #
        sources << [
          'assets'
        ]
      end
      security.x_frame_options 'DENY'

      security.x_content_type_options 'nosniff'
      security.x_xss_protection '1; mode=block'
      security.content_security_policy %{
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      }
      controller.prepare do
      end
      view.prepare do
        include Hanami::Helpers
        include PaymentApi::Assets::Helpers
      end
    end

    configure :development do
      handle_exceptions false
    end

    configure :test do
      handle_exceptions false
    end

    configure :production do

      assets do
        compile false

        fingerprint true

        subresource_integrity :sha256
      end
    end
  end
end
