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

food=['ハンバーガー','チーズバーガー','ピザ','ホットドッグ','コーラ','フライ','フライドチキン','サンドイッチ','マカロニ','フラペチーノ','ステーキ','ポテチ','ドーナツ']

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    logger.warn("400")
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  
  events.each do |event|
    for j in 0...food.size
      if event.message['text'].include?(food[j])
        food.delete_at(j)
        break
      end
      
        
    end
    if event.message['text'].include?('ハンバーガー')
      message = [
        {
          type:'text',
          text: 'マックのハンバーガーは２５０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/wQ4tdms/hamburger-1238246-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/wQ4tdms/hamburger-1238246-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('チーズバーガー')
      message=[
        {
          type:'text',
          text: 'マックのハンバーガーは３００カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/5G75bWq/hamburger-2201749-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/5G75bWq/hamburger-2201749-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('ピザ')
      message=[
        {
          type:'text',
          text: 'コストコのチーズピザは一切れ７１０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/Sddmpdj/pizza-3525673-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/Sddmpdj/pizza-3525673-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('ホットドッグ')
      message=[
        {
          type:'text',
          text: 'コストコのホットドッグは５６０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/p1Yqw7t/food-3233217-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/p1Yqw7t/food-3233217-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('コーラ')
      message=[
        {
          type:'text',
          text: 'コカ・コーラは５００mLあたり２２５カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/WgBKBdW/drink-462776-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/WgBKBdW/drink-462776-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('フライ')
      message=[
        {
          type:'text',
          text: 'マックの中くらいのポテトフライは３４０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/Z2gp9g8/fast-food-1839052-640.jpg',
          previewImageUrl: 'https://i.ibb.co/Z2gp9g8/fast-food-1839052-640.jpg'
        }
      ]
    elsif event.message['text'].include?('フライドチキン')
      message=[
        {
          type:'text',
          text: 'KFCのフライドチキンは一本１７０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/MsbYxH1/food-2202358-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/MsbYxH1/food-2202358-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('サンドイッチ')
      message=[
        {
          type:'text',
          text: 'サブウェイのフットロングサンドイッチは９００カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/8YHBHFN/sandwich-5056991-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/8YHBHFN/sandwich-5056991-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('マカロニ')
      message=[
        {
          type:'text',
          text: 'マカロニチーズは１カップ4００カロリーだよ'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/DGXSFYM/mac-and-cheese-1046626-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/DGXSFYM/mac-and-cheese-1046626-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('フラペチーノ')
      message=[
        {
          type:'text',
          text: 'スタバのフラペチーノはグランデ（４７３ｍL）あたり２４０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/8XntDLj/coffee-5893926-640.jpg',
          previewImageUrl: 'https://i.ibb.co/8XntDLj/coffee-5893926-640.jpg'
        }
      ]
    elsif event.message['text'].include?('ステーキ')
      message=[
        {
          type:'text',
          text: 'ステーキなら２００ｇで６００カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/mt48qzr/ai-generated-8006206-1280.webp',
          previewImageUrl: 'https://i.ibb.co/mt48qzr/ai-generated-8006206-1280.webp'
        }
      ]
    elsif event.message['text'].include?('ポテチ')
      message=[
        {
          type:'text',
          text: 'Lay\'sの小さい袋で２４０カロリーだよ。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/60g4HBQ/potato-chips-448737-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/60g4HBQ/potato-chips-448737-1280.jpg'
        }
      ]
    elsif event.message['text'].include?('ドーナツ')
      message=[
        {
          type:'text',
          text: 'クリスピークリームドーナツ一つで１９０カロリーだよ。。'
        },
        {
          type:'image',
          originalContentUrl:'https://i.ibb.co/jrP5wqG/donuts-179248-1280.jpg',
          previewImageUrl: 'https://i.ibb.co/jrP5wqG/donuts-179248-1280.jpg'
        }
      ]
    else
      #foodList='他にも'
#      for j in 0..food.size do
#        foodList+=food[j]
#        foodList+='、'
#      end
#      foodList+='についてわかるよ'

      responses=['聞いたことない食べ物だなぁ。',"#{food[rand(food.size)]} とかならわかるよ。"]
      message = {
        type:'text',
        text: responses[rand(responses.size)]
      }
    end
    
    client.reply_message(event['replyToken'], message)
  end

  "OK"
end