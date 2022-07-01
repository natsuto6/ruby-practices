#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')

shots = []
scores.each do |score|
  if score == 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, i|
  if i < 9 && frame[0] == 10
    point += 10 + frames[i + 1].sum
    point += frames[i + 2][0] if frames[i + 1][0] == 10
  elsif i < 9 && frame.sum == 10
    point += 10 + frames[i + 1][0]
  else
    point += frame.sum
  end
end

puts point
