# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @shots = shots
  end

  def score
    @frames = create_frames
    total_score = 0
    (0..9).each do |frame_index|
      frame = Frame.new(@frames[frame_index])
      total_score += frame.score
      @frames[frame_index + 1] ||= []
      @frames[frame_index + 2] ||= []
      total_score += calculate_bonus_points(frame_index, frame)
    end
    total_score
  end

  def create_frames
    frame = []
    frames = []
    @shots.each do |s|
      frame << s
      if frames.length < 10
        if frame.length == 2 || s == 'X'
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << s
      end
    end
    frames
  end

  def calculate_bonus_points(frame_index, frame)
    if frame.strike?
      next_two_shots = (@frames[frame_index + 1] + @frames[frame_index + 2]).slice(0, 2)
      next_two_shots.sum { |s| Shot.new(s).score }
    elsif frame.spare?
      next_shot = @frames[frame_index + 1][0]
      Shot.new(next_shot).score
    else
      0
    end
  end
end
