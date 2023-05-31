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

  def hard_link
    stat.nlink
  end

  def user
    Etc.getpwuid(stat.uid).name
  end

  def group
    Etc.getgrgid(stat.gid).name
  end

  def filesize
    stat.size
  end

  def mtime
    File.mtime(file)
  end
end
