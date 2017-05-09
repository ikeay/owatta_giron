require 'twitter'
require 'dotenv/load'

class OwattaGiron
  def initialize
# REST API
# 注意用アカウントのキー
    @client_rest = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('OUTPUT_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('OUTPUT_CONSUMER_SECRET')
      config.access_token        = ENV.fetch('OUTPUT_OAUTH_TOKEN')
      config.access_token_secret = ENV.fetch('OUTPUT_OAUTH_TOKEN_SECRET')
    end

# Streaming API
# 引用ツイートに困っているアカウントのキー
    @client_stream = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV.fetch('INPUT_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('INPUT_CONSUMER_SECRET')
      config.access_token        = ENV.fetch('INPUT_OAUTH_TOKEN')
      config.access_token_secret = ENV.fetch('INPUT_OAUTH_TOKEN_SECRET')
    end

# 引用されて困っているツイートのURL
    @url = ENV.fetch('TWEET_URL')
  end

# ユーザーのタイムラインを監視し、引用ツイートを見つけ次第ツイート
  def fetch_and_notify
    @client_stream.user do |tweet|
      if tweet.is_a?(Twitter::Streaming::Event) && tweet.name == :quoted_tweet
        if tweet.target_object.quoted_tweet.url.to_s == @url
         username = tweet.target_object.user.screen_name
         tweetid = tweet.target_object.id
         @client_rest.update("@#{username} 本ツイートは数日前に議論が盛り上がり、すでに収束しています。引用ツイートは通知が飛んできてつらいので、リツイートにてお楽しみいただけると幸いです。建設的なご意見を投稿していただいていたら申し訳ございません。#{Time.now.to_i}", in_reply_to_status_id: tweetid)
        end
      end
    end
  end

end
