# coding:UTF-8

#URLにアクセスするためのライブラリの読み込み　　　　　
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# UserAgentをIEに偽装
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

# スクレイピング先のURL
month = "month-1003/1"
url = "http://twilog.org/shifumin/#{month}"

charset = nil
html = open(url, "User-Agent" => UserAgent) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトルを表示
#p doc.title

doc.xpath('//p[@class = "tl-text"]').each do |node|
  p node.text
end

