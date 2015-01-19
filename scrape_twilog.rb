# coding:UTF-8

require 'bundler/setup'

#URLにアクセスするためのライブラリの読み込み　　　　　
#require 'open-uri'
# Nokogiriライブラリの読み込み
#require 'nokogiri'


# UserAgentをIEに偽装
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'

# 何年何月 2014年4月なら1404
month = ARGV[0]

# その月のツイートのページ数 10ページ目まであるなら10
max_page = ARGV[1].to_i
page_range = 1..max_page


# 各ページごとの処理
page_range.each do |page|
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


  # 日付とツイート数とツイートをノードに格納
  doc.xpath("//h3/a[1] | //h3/span | //section/article/p[@class = 'tl-text']").each do |node| 

  # 日にちごとに改行を入れる
  if node.name == "a"
     puts "\n"
  end

   # リプライを除く(RTは除かない)
   if node.text[0] != "@"
    puts node.text
    end
  end


  # 1秒間だけ待ってやる
  sleep(1)


end
