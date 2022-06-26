#!/usr/bin/env ruby
# frozen_string_literal: true

scores = ARGV[0].split(',')
shots = []

while scores.any?
  shot = scores.shift
  if shot == 'X' && shots.size < 18
    shots << 10
    shots << 0
  elsif shot == 'X'
    shots << 10
  else
    shots << shot.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

frames[-2].push frames.pop[0] if frames[-1].size == 1

point = 0
9.times do |i|
  point +=  if frames[i][0] == 10
              if frames[i + 1][0] == 10
                if i < 8
                  frames[i].sum + frames[i + 1][0] + frames[i + 2][0]
                else
                  frames[i].sum + frames[i + 1][0] + frames[i + 1][1]
                end
              else
                frames[i].sum + frames[i + 1][0] + frames[i + 1][1]
              end
            elsif frames[i].sum == 10
              frames[i].sum + frames[i + 1][0]
            else
              frames[i].sum
            end
end

point += frames[9].sum
puts point
