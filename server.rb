require './word'
require 'sinatra'
require 'pry'
get '/' do
  phrase = params["text"]
  if phrase != nil
    "#{EmojiNet.new().expand(phrase)}\n(#{phrase})"
  else
    "no phrase given!"
  end
end
