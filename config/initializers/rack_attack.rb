class Rack::Attack
  throttle('req/ip', limit: 10, period: 30) do |request|
    request.ip
  end
end