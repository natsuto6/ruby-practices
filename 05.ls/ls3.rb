# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
params = {}
opt.on('-r') { |v| params[:r] = v }
opt.parse!(ARGV)

def find_lists(params)
  current_files = Dir.glob('*')
  params[:r] ? current_files.reverse : current_files
end

def display_lists(lists, column)
  line_count = (lists.length.to_f / column).ceil
  line_count.times do |line|
    lists.each_slice(line_count) do |columns|
      print columns[line]&.ljust(16)
    end
    print "\n"
  end
end

lists = find_lists(params)
display_lists(lists, 3)
