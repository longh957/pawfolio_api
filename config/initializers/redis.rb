# Setup for resque and redis
# require 'resque-scheduler'
# require 'resque/scheduler/server'
# Redis setup
redis_url = ENV['REDISCLOUD_URL']
$redis = Redis.new(url: redis_url)
# $redis = Redis::Namespace.new('pawfolio', redis: Redis.new(redis_url))
# Resque.redis = $redis

# Resque Auth
# Resque::Server.use(Rack::Auth::Basic) do |user, password|
#   user == ENV['RESQUE_USER'] && password == ENV['RESQUE_PASSWORD']
# end
