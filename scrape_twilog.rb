# coding:UTF-8

#URLにアクセスするためのライブラリの読み込み　　　　　
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# UserAgentをIEに偽装
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

# 何年何月
month = 1004
m = month.to_s
# ページ数
# max_page = 14
max_page = [*(1..14)]

max_page.each do |page|

  p = page.to_s
  # スクレイピング先のURL
  url = "http://twilog.org/shifumin/month-#{m}/#{p}"

  charset = nil
  html = open(url, "User-Agent" => UserAgent) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc.xpath('//p[@class = "tl-text"]').each do |node|
   p node.text
  end

  p "\n"
  sleep(2)
end
