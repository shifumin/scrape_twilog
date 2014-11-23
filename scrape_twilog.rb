# coding:UTF-8

#URLにアクセスするためのライブラリの読み込み　　　　　
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# UserAgentをIEに偽装
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

# 何年何月 2014年4月 1404
month = ARGV[0]

# ページ数
max_page = ARGV[1].to_i
page_a = Array.new
# page_a = [1..(max_page)]したい
max_page.times do |p|
  page_a << p + 1
end


page_a.each do |page|
  p = page.to_s
  # スクレイピング先のURL
  url = "http://twilog.org/shifumin/month-#{month}/#{p}"

  charset = nil
  html = open(url, "User-Agent" => UserAgent) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc2 = doc.xpath('//h3[@class = "title01"]')
  puts doc2.xpath('a').text
  puts doc2.xpath('span').text
  
  # 本文を抽出してリプライ以外のツイートを表示
  doc.xpath('//p[@class = "tl-text"]').each do |node|
    if node.xpath('a').text[0] != "@"
      puts node.text
    end
  end

  # 1秒間だけ待ってやる
  sleep(1)
end
