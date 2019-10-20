require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV.fetch('SIDEKIQ_USER'){ 'sidekiq' } , ENV.fetch('SIDEKIQ_PASSWORD'){ 'zimobi' }]
end