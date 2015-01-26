require 'yelp'

# client = Yelp::Client.new({ consumer_key: ENV["YELP_CONSUMER_KEY"],
#   consumer_secret: ENV["YELP_CONSUMER_SECRET"],
#   token: ENV["YELP_TOKEN"],
#   token_secret: ENV["YELP_TOKEN_SECRET"]
#   })

  #
  Yelp.client.configure do |config|
    config.consumer_key = ENV["YELP_CONSUMER_KEY"]
    config.consumer_secret = ENV["YELP_CONSUMER_SECRET"]
    config.token = ENV["YELP_TOKEN"]
    config.token_secret = ENV["YELP_TOKEN_SECRET"]
  end
