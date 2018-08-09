require 'imgkit'
require 'pry'

IMGKit.configure do |config|
  unless ARGV.empty?
    config.wkhtmltoimage = './bin/wkhtmltoimage'
  else
    config.wkhtmltoimage = './bin/wkhtmltoimage-amd64'
  end
end

class ColorMe

  def initialize
  @px = 55
  @width = 1400
  @colors = {
    'b' => 'blue',
    't' => 'teal',
    'y' => 'yellow',
    'f' => 'fuschia',
    'p' => 'purple',
    'g' => 'green',
    'r' => 'red',
    'D' => 'black'
  }
  end

  def process(text)
    input = text.strip
    output = []
    if input[0] != "{"
      input = "{D}" + input
    end
    while input.length > 0 do
      result = input.match(/^({.})(.*?[{])/)
      if result != nil
        output << span(@colors[result[1][1]], result[2][0..-2])
        input = input.gsub(result[0][0..-2], "")
      else
        output << span(@colors[input[1]], input[3..-1])
        input = ""
      end
    end
    output
  end

  def span(color, text)
    "<span style='font-size: #{@px}px;color: #{color}'>#{text}</span>"
  end

  def render(text)
    img = IMGKit.new(process(text).join(" "), width: @width).to_jpeg
    File.write('./out/image.jpeg', img)
  end

end

unless ARGV.empty?
  puts ColorMe.new().render(ARGV.first)
end
