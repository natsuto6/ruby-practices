# frozen_string_literal: true

require 'etc'

class FileInfo
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def stat
    File.stat(file)
  end

  def permissions
    FilePermission.new(file).format_permissions
  end

  def hard_link_length
    stat.nlink.to_s.length
  end

  def user_length
    Etc.getpwuid(stat.uid).name.length
  end

  def group_length
    Etc.getgrgid(stat.gid).name.length
  end

  def file_size_length
    stat.size.to_s.length
  end

  def mtime_formatted
    File.mtime(file).strftime('%m %d %H:%M')
  end
end
