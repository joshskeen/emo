require './word'
require 'sinatra'
require 'slack-ruby-client'
require 'pry'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

post '/' do
  #phrase = params["text"]
  puts "about to print params"
  push = JSON.parse(request.body.read)
  puts push
  puts params
  #if phrase != nil
    #"#{EmojiNet.new().expand(phrase)}\n(#{phrase})"
  #else
    #"no phrase given!"
  #end
  200
end
