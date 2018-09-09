# coding: utf-8
require "sinatra"
require "rss"

get '/' do
  say=params[:say]||"test"
  od=params[:od]
  case od
  when "weekweather" then
    week_weather
  when "nowweather" then
    now_weather
  when "time" then
    now_time
  end
end
def get_rss_items()
  url = "http://weather.livedoor.com/forecast/rss/area/340010.xml"
  return RSS::Parser.parse(url).channel.items
end
def week_weather()
  get_rss_items().each do |i|
    jsay(i.description)
  end
end
def now_weather()
  get_rss_items().each do |i|
    jsay(i.title)
  end
end
def now_time()
  d = Time.now
  str = d.strftime("%H時%M分%S秒")
  jsay("#{str}")
end

def jsay(cmd)
  return if cmd == ""
  system("~/jsay.sh #{cmd}")
end
