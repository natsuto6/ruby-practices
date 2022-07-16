# #!/usr/bin/env ruby
# frozen_string_literal: true

require 'find'

lists = []
def find_lists(dir, files)
  Find.find(dir) do |file|
    file_name = File.basename(file)
    next if File.basename(dir) == file_name || /^\./ =~ file_name

    files << case File.ftype(file)
             when 'directory', 'file'
               file_name
             end
  end
end

def display_lists(lists, column)
  each_column = lists.length / column + 1
  0.upto(each_column).each_with_index do |line, idx|
    lists.each_slice(each_column) do |columns|
      print columns[line].ljust(16) if columns [line]
    end
    print "\n" unless idx == each_column - 1
  end
end

current_dir = File.absolute_path('.')
find_lists(current_dir, lists)
display_lists(lists, 3)
