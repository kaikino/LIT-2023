require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

get '/' do
  erb :index
end

get "/game" do
  erb :game
end

get "/result" do
  erb :result
end

get "/rankings" do
  #@rankings = Ranking.all.order("score desc").limit(5)
  @rankings1 = Ranking.where(level: 1).order(score: :desc).limit(5)
  @rankings2 = Ranking.where(level: 2).order(score: :desc).limit(5)
  @rankings3 = Ranking.where(level: 3).order(score: :desc).limit(5)
  
  erb :rankings
end

post "/record" do
  ranking = Ranking.create({
    name: params[:name],
    score: (params[:score].to_i*10).to_f,
    level: params[:level]
  })
  redirect "/"
end