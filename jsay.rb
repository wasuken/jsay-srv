# coding: utf-8
require "sinatra"
require "rss"
require "todoist"
require "nokogiri"
require "parseconfig"
require "open-uri"

CONFIG=ParseConfig.new("config")
CLIENT = Todoist::Client.create_client_by_token(CONFIG["token"])

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
  when "todo" then
    items_list =  CLIENT.sync_items.collection
    p items_list.first.first
    items_list.each do |i|
      jsay(i.last.content)
    end
  when "watchnico" then
    # ニコニコ生放送から今配信している放送のタイトルを取得する。
    url="http://live.nicovideo.jp/search?keyword=%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0&sort=recent"
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    doc=Nokogiri::HTML.parse(html)
    doc.css(".result-list").first.css("a").each do |node|
      jsay(node.text())
    end
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
