# -*- coding: utf-8 -*-

require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

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

# 次のページがあるかどうかを「次のページ」のhref属性の有無で調べるメソッド
def has_next_page?(doc)
  doc.xpath("//*[@class='nav-next']").each do |node|
    return true if node.child.has_attribute?('href')
    return false
  end
end

# 改行を入れる処理を実装する
def get_tweet_data(doc)
  doc.xpath("//div[@id='content']/h3 | //article[@class='tl-tweet']").each do |node|
    # 日付を表示する
    date = node.xpath("a[1]").text
    puts date unless date.empty?

    # ツイート数を表示する
    tweet_count = node.xpath("span").text
    puts tweet_count unless tweet_count.empty?

    # リプライ以外のツイートを表示する
    tweet = node.xpath("p[@class='tl-text']").text
    puts tweet unless tweet.empty? || tweet[0] == '@'
    puts "\n"
  end
end

# main
base_url = "http://twilog.org"

# 標準入力からどのTwitterIDの何年何月のツイートを取得するかを入力する
puts 'TwitterIDは？'
user = STDIN.gets.chomp
puts '何年？'
year = STDIN.gets.to_i
puts '何月？'
month = STDIN.gets.to_i

yearmonth = "#{year - 2000}" + format("%02d", month)
num = 1

loop do
  url = "#{base_url}/#{user}/month-#{yearmonth}/#{num}"
  doc = get_nokogiri_doc(url)
  get_tweet_data(doc)
  break unless has_next_page?(doc)
  num += 1
end
