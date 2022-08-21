# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPE = {
  '10' => 'p',
  '20' => 'c',
  '40' => 'd',
  '60' => 'b',
  '100' => '-',
  '120' => 'l',
  '140' => 's'
}.freeze

PERMISSION = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

opt = OptionParser.new
params = {}
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

def find_lists(params)
  current_files = Dir.glob('*')
  params[:r] ? current_files.reverse! : current_files
  if params[:l]
    total_block_number(current_files)
    current_files.each do |file|
      file_detail_display(file, current_files)
    end
  else
    display_lists(current_files, 3)
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

def total_block_number(current_files)
  total = current_files.map do |file|
    get_file_info(file).blocks
  end
  puts "total #{total.sum}"
end

def get_file_info(file)
  File.stat(file)
end

def file_detail_display(file, files)
  file_stats = files.map { |f| get_file_info(f) }
  max_length = maximums(file_stats)

  permission = get_permissions(file)
  hard_link = File.stat(file).nlink.to_s.rjust(max_length[:hard_link])
  user = Etc.getpwuid(File.stat(file).uid).name.rjust(max_length[:user])
  group = Etc.getgrgid(File.stat(file).gid).name.rjust(max_length[:group])
  file_size = File.stat(file).size.to_s.rjust(max_length[:filesize])
  time = File.mtime(file).strftime('%m %d %H:%M')
  filename = file

  puts "#{permission}  #{hard_link} #{user}  #{group}  #{file_size} #{time} #{filename} "
end

def maximums(file_stats)
  hardlinks = []
  users = []
  groups = []
  filesize = []

  file_stats.each do |file|
    hardlinks << file.nlink.to_s
    users << Etc.getpwuid(file.uid).name
    groups << Etc.getgrgid(file.gid).name
    filesize << file.size.to_s
  end

  {
    hard_link: hardlinks.max_by(&:length).length,
    user: users.max_by(&:length).length,
    group: groups.max_by(&:length).length,
    filesize: filesize.max_by(&:length).length
  }
end

def get_permissions(file)
  file_stat = File.lstat(file).mode.to_s(8)
  permission_number = file_stat[2..4]
  type_of_file = FILE_TYPE[(file_stat[0..-4])]
  permission_code = permission_number.chars.map do |n|
    PERMISSION[n.to_i]
  end.join('')
  type_of_file + permission_code
end

find_lists(params)
