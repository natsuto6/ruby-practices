# frozen_string_literal: true

class FilePermission
  PERMISSIONS = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  FILE_TYPE = {
    '10' => 'p',
    '20' => 'c',
    '40' => 'd',
    '60' => 'b',
    '100' => '-',
    '120' => 'l',
    '140' => 's'
  }.freeze

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def format_permissions
    type_of_file + permission_code
  end

  private

  def type_of_file
    FILE_TYPE[file_mode[0..-4]]
  end

  def permission_code
    permission_numbers.map { |n| PERMISSIONS[n] }.join
  end

  def file_mode
    File.lstat(file).mode.to_s(8)
  end

  def permission_numbers
    file_mode[-3..].chars.map(&:to_i)
  end
end
