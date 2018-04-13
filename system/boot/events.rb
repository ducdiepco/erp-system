# Container.finalize(:events) do |container|
#   if Hanami.env == 'production'
#     uri = URI.parse(ENV.fetch('REDIS_URL', ''))
#     redis = ConnectionPool.new(size: 10, timeout: 3) do
#       Redis.new(driver: :hiredis, host: uri.host, port: uri.port, password: uri.password)
#     end
#     container.register(:events, Hanami::Events.initialize(:redis, redis: redis))
#   else
#     container.register(:events, Hanami::Events.initialize(:memory_async))
#   end
#
# end
