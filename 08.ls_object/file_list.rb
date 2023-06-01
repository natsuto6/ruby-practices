# frozen_string_literal: true

class FileList
  def initialize(params)
    @params = params
  end

  def display_lists
    file_match_option = @params[:a] ? File::FNM_DOTMATCH : 0
    current_files = Dir.glob('*', file_match_option).map { |file| FileInfo.new(file) }
    @params[:r] ? current_files.reverse : current_files
    if @params[:l]
      total_block_number(current_files)
      current_files.each { |file_info| display_file_details(file_info, current_files) }
    else
      display_lists_simple(current_files, 3)
    end
  end

  private

  def display_lists_simple(lists, column)
    max_filename_length = lists.map { |file_info| file_info.file.length }.max
    line_count = (lists.length.to_f / column).ceil
    line_count.times do |line|
      lists.each_slice(line_count) do |columns|
        print columns[line].file&.ljust(max_filename_length + 2) if columns[line]
      end
      print "\n"
    end
  end

  def total_block_number(current_files)
    total = current_files.sum { |file| file.stat.blocks }
    puts "total #{total}"
  end

  def display_file_details(file_info, files)
    max_lengths = calculate_maximum_lengths(files)
    permissions = file_info.permissions
    hard_link = file_info.hard_link.to_s.rjust(max_lengths[:hard_link])
    user = file_info.user.rjust(max_lengths[:user])
    group = file_info.group.rjust(max_lengths[:group])
    filesize = file_info.filesize.to_s.rjust(max_lengths[:filesize])
    time = file_info.mtime.strftime('%m %d %H:%M')
    filename = file_info.file
    puts "#{permissions}  #{hard_link} #{user}  #{group}  #{filesize} #{time} #{filename} "
  end

  def calculate_maximum_lengths(file_stats)
    lengths_list = file_stats.map do |file|
      {
        hard_link: file.hard_link.to_s.length,
        user: file.user.length,
        group: file.group.length,
        filesize: file.filesize.to_s.length
      }
    end

    lengths_list.each_with_object({ hard_link: 0, user: 0, group: 0, filesize: 0 }) do |lengths_hash, max_lengths|
      lengths_hash.each do |key, value|
        max_lengths[key] = [max_lengths[key] || 0, value].max
      end
    end
  end
end
