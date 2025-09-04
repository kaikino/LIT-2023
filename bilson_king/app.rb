require "bundler/setup"
Bundler.require
require "sinatra/reloader" if development?

enable :sessions

configure do
  set :title, "スタバ王"
  set :colors, {0=>'#EBCBFF', 1=>'#FFC7C7', 2=>'#FFEDC9', 3=>'#97E4DA'}
  set :quizzes, {
    0=>{
      question: "スターバックスはどこで初めて開業した？",
      choices: [
        { text: "日本", correct: false },
        { text: "南極", correct: false },
        { text: "イギリス", correct: false },
        { text: "アメリカ", correct: true }
      ],
    },
    1=>{
      question: "スタバはいつ創業した？",
      choices: [
        { text: "1953", correct: false },
        { text: "1971", correct: true },
        { text: "1992", correct: false },
        { text: "2009", correct: false }
      ],
    },
    2=>{
      question: "スタバのロゴは何者？",
      choices: [
        { text: "創業者", correct: false },
        { text: "女王", correct: false },
        { text: "自由の女神", correct: false },
        { text: "セイレーン", correct: true }
      ],
    },
    3=>{
      question: "スタバの店の数は？",
      choices: [
        { text: "2,000", correct: false },
        { text: "12,000", correct: false },
        { text: "34,000", correct: true },
        { text: "89,000", correct: false }
      ],
    },
    4=>{
      question: "日本で1号店を開いたのは何年？",
      choices: [
        { text: "1996", correct: true },
        { text: "1999", correct: false },
        { text: "2006", correct: false },
        { text: "2011", correct: false }
      ],
    },
    5=>{
      question: "一番人気なフラペチーノは？",
      choices: [
        { text: "ダーク モカ チップ フラペチーノ", correct: true },
        { text: "抹茶クリームフラペチーノ", correct: false },
        { text: "ピーチ フラペチーノ", correct: false },
        { text: "キャラメル フラペチーノ®", correct: false }
      ],
    },
  }
end

$results = []

before do
  @title = settings.title
  @colors = settings.colors
  @quiz_length = settings.quizzes.length
  if session[:result] == nil
    session[:result] = []
  end
end

get '/' do
  session[:result] = []
  erb :index
end

get '/quiz/:id' do
  @quiz_id = params[:id].to_i
  if @quiz_id >= @quiz_length
    redirect '/'
  end
  @quiz = settings.quizzes[@quiz_id]
  erb :quiz
end

post '/quiz/:id' do
  quiz_id = params[:id].to_i
  choice_index = params[:choice_index].to_i

  session[:result][quiz_id] = {
    id: quiz_id,
    choice_index: choice_index,
    is_correct: settings.quizzes[quiz_id][:choices][choice_index][:correct]
  }
  if quiz_id == @quiz_length - 1
    redirect '/result'
  else
    redirect "/quiz/#{quiz_id + 1}"
  end
end

get '/result' do
  @correct_count = 0
  session[:result].each do |answer|
    if answer[:is_correct] == true
       @correct_count = @correct_count + 1
    end
  end
  erb :result
end

get '/result/:id' do
  @quiz_id = params[:id].to_i
  if $results.length == 0 || @quiz_id >= @quiz_length
    redirect "/"
  end
  @quiz = settings.quizzes[@quiz_id]
  @quiz_result = []
  $results.each do |result|
    @quiz_result.push(result[:detail][@quiz_id])
  end
  @choice_counts = @quiz_result.group_by { |h| h[:choice_index] }.transform_values(&:count)
  @sorted_counts = @choice_counts.sort_by { |_, v| v }.to_h.transform_values(&:to_f).transform_values { |v| (v / @quiz_result.length * 100).to_i }
  erb :record
end

get '/ranking' do
  if $results.length == 0
    redirect "/"
  end
  @results = $results
  erb :ranking
end

post '/ranking/new' do
  if session[:result] == []
    redirect '/'
  end
  correct_num = 0
  session[:result].each do |answer|
    if answer[:is_correct] == true
      correct_num = correct_num + 1
    end
  end
  $results.push({
    name: params[:name],
    score: correct_num,
    detail: session[:result]
  })
  session[:result] = []
  redirect "/result/0"
end
