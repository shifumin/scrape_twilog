# coding:UTF-8

require 'bundler/setup'

#URLにアクセスするためのライブラリの読み込み　　　　　
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'


# UserAgentをIEに偽装
UserAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'


# 標準入力から何年何月のものをスクレイピングするか取得
puts "何年？  例:2014"
year = STDIN.gets
year.chomp!

puts "何月？  例:04"
month =STDIN.gets
month.chomp!

y_m = year[-2, 2] + month


=begin
# 何年何月か 2014年4月なら201404と入力されるので、monthに1404を格納する
month = ARGV[0][-4, 4]
=end

# 各ページごとの処理
catch(:break_loop) do
  page = 0

  while 1
    page += 1    
    p = page.to_s
    # スクレイピング先のURL
    url = "http://twilog.org/shifumin/month-#{y_m}/#{p}"

    charset = nil
    html = open(url, "User-Agent" => UserAgent) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)


    # ツイートが見つからないとループを抜ける
    doc.xpath("//section/div/p").each do |node|
      if node.text == "ツイートが見つかりませんでした"
        throw :break_loop
      end
    end


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
end
