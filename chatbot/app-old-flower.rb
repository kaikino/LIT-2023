require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require "fileutils"

# もし開発環境であれば MessagingAPI も実行する
if development?
  require './lib/messaging_api/messaging_api'
end

# .env ファイルを読み込む
Dotenv.load

# 画像データ保存用のディレクトリを作成
FileUtils.mkdir_p( "data" ) unless Dir.exist?("data")

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

food=['ハンバーガー']
calories=['300']
links=['https://ibb.co/dpDZfYg']

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    logger.warn("400")
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  
  events.each do |event|
    for i in 0..food.size
      if event.message['text'].include?(food[i])
        message = [
          {
            type:'text',
            text: calories[i]
          },
          {
            type:'image',
            originalContentUrl: links[i],
            previewImageUrl: links[i]
          }
        ]
      end
    end
    client.reply_message(event['replyToken'], message)
  end

  "OK"
end