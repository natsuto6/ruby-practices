# frozen_string_literal: true

class FileList
  COLUMNS = 3

  def initialize(params)
    @params = params
  end

  def display_lists
    file_match_option = @params[:a] ? File::FNM_DOTMATCH : 0
    files = Dir.glob('*', file_match_option).map { |file| FileInfo.new(file) }
    current_files = @params[:r] ? files.reverse : files
    @params[:l] ? display_in_long_format(current_files) : display_in_short_format(current_files)
  end

  private

  def display_in_short_format(lists)
    max_filename_length = lists.map { |file_info| file_info.file.length }.max
    line_count = (lists.length.to_f / COLUMNS).ceil
    line_count.times do |line|
      lists.each_slice(line_count) do |columns|
        print columns[line]&.file&.ljust(max_filename_length + 2)
      end
      print "\n"
    end
  end

  def display_in_long_format(current_files)
    display_total_block_number(current_files)
    max_lengths = calculate_maximum_lengths(current_files)
    current_files.each { |file_info| display_file_details(file_info, max_lengths) }
  end

  def display_total_block_number(current_files)
    total = current_files.sum { |file| file.stat.blocks }
    puts "total #{total}"
  end

  def display_file_details(file_info, max_lengths)
    permissions = file_info.permissions
    hard_link = file_info.hard_link.to_s.rjust(max_lengths[:hard_link])
    user = file_info.user.rjust(max_lengths[:user])
    group = file_info.group.rjust(max_lengths[:group])
    filesize = file_info.filesize.to_s.rjust(max_lengths[:filesize])
    time = file_info.mtime.strftime('%m %d %H:%M')
    filename = file_info.file
    puts "#{permissions}  #{hard_link} #{user}  #{group}  #{filesize} #{time} #{filename}"
  end

  def calculate_maximum_lengths(file_stats)
    max_lengths = {
      hard_link: 0,
      user: 0,
      group: 0,
      filesize: 0
    }

    file_stats.each do |file|
      max_lengths[:hard_link] = [max_lengths[:hard_link], file.hard_link.to_s.length].max
      max_lengths[:user] = [max_lengths[:user], file.user.length].max
      max_lengths[:group] = [max_lengths[:group], file.group.length].max
      max_lengths[:filesize] = [max_lengths[:filesize], file.filesize.to_s.length].max
    end

    max_lengths
  end
end
