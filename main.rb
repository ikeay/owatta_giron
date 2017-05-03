require 'twitter'

# 引用ツイートに困っているアカウントのキー
INPUT_CONSUMER_KEY       = ENV.fetch('INPUT_CONSUMER_KEY')
INPUT_CONSUMER_SECRET    = ENV.fetch('INPUT_CONSUMER_SECRET')
INPUT_OAUTH_TOKEN        = ENV.fetch('INPUT_OAUTH_TOKEN')
INPUT_OAUTH_TOKEN_SECRET = ENV.fetch('INPUT_OAUTH_TOKEN_SECRET')

# 注意用アカウントのキー
OUTPUT_CONSUMER_KEY       = ENV.fetch('OUTPUT_CONSUMER_KEY')
OUTPUT_CONSUMER_SECRET    = ENV.fetch('OUTPUT_CONSUMER_SECRET')
OUTPUT_OAUTH_TOKEN        = ENV.fetch('OUTPUT_OAUTH_TOKEN')
OUTPUT_OAUTH_TOKEN_SECRET = ENV.fetch('OUTPUT_OAUTH_TOKEN_SECRET')

# REST API
client_rest = Twitter::REST::Client.new do |config|
  config.consumer_key        = OUTPUT_CONSUMER_KEY   
  config.consumer_secret     = OUTPUT_CONSUMER_SECRET
  config.access_token        = OUTPUT_OAUTH_TOKEN
  config.access_token_secret = OUTPUT_OAUTH_TOKEN_SECRET
end

# Streaming API
client_stream = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = INPUT_CONSUMER_KEY   
  config.consumer_secret     = INPUT_CONSUMER_SECRET
  config.access_token        = INPUT_OAUTH_TOKEN
  config.access_token_secret = INPUT_OAUTH_TOKEN_SECRET
end

# 引用されて困っているツイートのURL
url = ENV.fetch('TWEET_URL')

# ユーザーのタイムラインを監視し、引用ツイートを見つけ次第ツイート
client_stream.user do |tweet|
  if tweet.is_a?(Twitter::Streaming::Event) && tweet.name == :quoted_tweet
    if tweet.target_object.quoted_tweet.url.to_s == url
      username = tweet.target_object.user.screen_name
      tweetid = tweet.target_object.id
      client_rest.update("@#{username} 本ツイートは数日前に議論が盛り上がり、すでに収束しています。引用ツイートは通知が飛んできてつらいので、リツイートにてお楽しみいただけると幸いです。建設的なご意見を投稿していただいていたら申し訳ございません。#{Time.now.to_i}", in_reply_to_status_id: tweetid)
    end
  end
end
