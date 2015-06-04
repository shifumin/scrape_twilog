# -*- coding: utf-8 -*-

require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

def get_nokogiri_doc(url)
  begin
    html = open(url)
  rescue Open::HTTPError
    return
  end
  Nokogiri::HTML(html.read, nil, 'utf-8')
end

# 「次のページ」のa hrefがあるかを調べる関数(作成中)
def has_next_page?(doc)
  doc.xpath("//ul[@class='nav-link mb10 mt0']/li").each do |element|
    return true if element.text == ""
    return false
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
  get_tweet_text(doc)
  break unless has_next_page?(doc)
  num += 1
end
