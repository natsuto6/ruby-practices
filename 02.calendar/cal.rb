#!/usr/bin/env ruby
require 'date'
require 'optparse'

#コマンドライン引数として年(y)と月(m)を受け取る
options = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.mon}")
year = options.values[0].to_i
mon = options.values[1].to_i

last_day = Date.new(year, mon, -1).day #月の最終日を取得
week = %w(日 月 火 水 木 金 土)
weekday = Date.new(year, mon).wday #曜日を取得

puts '      ' + mon.to_s + '月 ' + year.to_s #月と西暦を表示
puts week.join(" ") #曜日を間隔を開けて表示
print "   " * weekday #スペースを曜日の数作る

(1..last_day).each do |date| #月初〜最終日まで繰り返す
  print date.to_s.rjust(2) + " " #日付を右詰めで表示
  if Date.new(year, mon, date).wday == 6 #土曜日まで表示したら改行
    puts "\n"
  end
end
