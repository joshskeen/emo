require './word'
require './colorme'
require 'sinatra'
require 'slack-ruby-client'
require 'pry'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

post '/colorme' do
    client = Slack::Web::Client.new
    channel_id = params["channel_id"]
    phrase = params["text"]
    ColorMe.new().render(phrase)
    client.files_upload( channels: channel_id, title: '`', as_user: false,
                        file: Faraday::UploadIO.new('./out/image.jpeg', 'image/jpeg'))
    200
end

post '/' do
  puts "about to print params"
  phrase = params["text"]
  if phrase != nil
    client = Slack::Web::Client.new
    channel_id = params["channel_id"]
    expanded = EmojiNet.new().expand(phrase)
    response = "#{expanded}\n(#{phrase} -> #{expanded.gsub(':', '')})"
    client.chat_postMessage(channel: channel_id,
                            text: response,
                            as_user: true)
  else
    puts "no phrase given!"
  end
  200
end
