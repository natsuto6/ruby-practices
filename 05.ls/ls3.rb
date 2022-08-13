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
  total = []
  current_files.map do |file|
    total << get_file_info(file).blocks
  end
  puts "total #{total.sum}"
end

def get_file_info(file)
  File.stat(file)
end

def file_detail_display(file, files)
  max_length = maximums(files)

  permission = get_permissions(file)
  hard_link = get_hardlink(file).rjust(max_length[:hard_link])
  user = user_name(file).rjust(max_length[:user])
  group = group_name(file).rjust(max_length[:group])
  file_size = get_size(file).rjust(max_length[:filesize])
  time = files_created_time(file)
  filename = file

  puts "#{permission}  #{hard_link} #{user}  #{group}  #{file_size} #{time} #{filename} "
end

def maximums(files)
  hardlinks = []
  users = []
  groups = []
  filesize = []

  files.each do |file|
    hardlinks << get_hardlink(file)
    users << user_name(file)
    groups << group_name(file)
    filesize << get_size(file)
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

def get_hardlink(file)
  get_file_info(file).nlink.to_s
end

def user_name(file)
  Etc.getpwuid(get_file_info(file).uid).name
end

def group_name(file)
  Etc.getgrgid(get_file_info(file).gid).name
end

def get_size(file)
  File.size(file).to_s
end

def files_created_time(file)
  File.mtime(file).strftime('%m %d %H:%M')
end

find_lists(params)
