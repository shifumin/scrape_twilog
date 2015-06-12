# -*- coding: utf-8 -*-

require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'pp'

# UserAgentをIEに設定
USER_AGENT = "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; rv:11.0)"

def get_nokogiri_doc(url)
  begin
    html = open(url, "User-Agent" => USER_AGENT)
  rescue OpenURI::HTTPError
    return
  end
  Nokogiri::HTML(html.read, nil, 'UTF-8')
end

# 次のページがあるかどうかを「次のページ」のhref属性の有無で調べる関数
def has_next_page?(doc)
  doc.xpath("//*[@class='nav-next']").each do |node|
    return true if node.child.has_attribute?('href')
    return false
  end
end

# 日付とツイート数を表示するメソッド
def get_date(doc)
  doc.xpath("//h3").each do |node|
    puts node.xpath("a[1]").text
    puts node.xpath("span").text
  end
end

def get_tweet_text(doc)
  doc.xpath("").each do |element|
    puts element.text
  end
end

base_url = "http://twilog.org"
user = "shifumin"

# 検索年月
year = 2015
month = 6
yearmonth = "#{year - 2000}" + format("%02d", month)

num = 1

loop do
  url = "#{base_url}/#{user}/month-#{yearmonth}/#{num}"
  doc = get_nokogiri_doc(url)
  get_date(doc)
  break unless has_next_page?(doc)
  num += 1
end
