# Redis setup
redis_url = ENV['REDISCLOUD_URL']
$redis = Redis.new(url: redis_url)
