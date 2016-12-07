require 'sinatra'
require 'redis'
require 'cf-app-utils'

before do
  unless redis_credentials
    halt(500, %{
You must bind a Redis service instance to this application.

You can run the following commands to create an instance and bind to it:

  $ cf create-service redisent large redis-instance
  $ cf bind-service <app-name> redis-instance})
  end
end

put '/:key' do
  data = params[:data]
  if data
    redis_client.set(params[:key], data)
    status 201
    body 'success'
  else
    status 400
    body 'data field missing'
  end
end

get '/:key' do
  value = redis_client.get(params[:key])
  if value
    status 200
    body value
  else
    status 404
    body 'key not present'
  end
end

delete '/:key' do
  result = redis_client.del(params[:key])
  if result > 0
    status 200
    body 'success'
  else
    status 404
    body 'key not present'
  end
end

def redis_credentials
  if ENV['VCAP_SERVICES']
    CF::App::Credentials.find_by_service_label('redisent')
  end
end

def redis_client
  @client ||= Redis.new(
    url: redis_credentials.fetch('master'),
    # this library strictly requires sentinels to be a symbol
    # https://github.com/redis/redis-rb/issues/570
    :sentinels => redis_credentials.fetch('sentinels').map do |sentinel|
    {
      :host => sentinel.fetch('host'),
      :port => sentinel.fetch('port')
    }
    end,
    role: :master,
    password: redis_credentials.fetch('password')
  )
end
