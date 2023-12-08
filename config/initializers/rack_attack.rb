class Rack::Attack
  # limits to 10 requests for 30 seconds from same IP address to prevent DDOS or brute-force login
  throttle('req/ip', limit: 10, period: 30) do |request|
    request.ip
  end
end