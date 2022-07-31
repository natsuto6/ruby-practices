# !/usr/bin/env ruby
# frozen_string_literal: true

require 'find'

def find_lists(current_dir)
  Find.find(current_dir)
      .map { |n| File.basename(n) }
      .filter { |n| File.basename(current_dir) != n }
      .filter { |n| !n.start_with?('.') }
      .map do |n|
    case File.ftype(n)
    when 'directory', 'file'
      n
    end
  end
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

current_dir = File.absolute_path('.')
lists = find_lists(current_dir)
display_lists(lists, 3)
