require './word'
require 'sinatra'
require 'pry'
get '/' do
  if params["phrase"] != nil
    EmojiNet.new().expand(params["phrase"]) 
  else
    puts "no phrase given!"
  end
end
