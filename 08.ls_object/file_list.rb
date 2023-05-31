# frozen_string_literal: true

class FileList
  def initialize(params)
    @params = params
  end

  def display_lists
    file_match_option = @params[:a] ? File::FNM_DOTMATCH : 0
    current_files = Dir.glob('*', file_match_option).map { |file| FileInfo.new(file) }
    @params[:r] ? current_files.reverse! : current_files
    if @params[:l]
      total_block_number(current_files)
      current_files.each { |file| display_file_details(file, current_files) }
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
    total = current_files.map { |file| file.stat.blocks }
    puts "total #{total.sum}"
  end

  def display_file_details(file, files)
    max_length = maximums(files)
    permission = file.permissions
    hard_link = file.hard_link.to_s.rjust(max_length[:hard_link])
    user = file.user.rjust(max_length[:user])
    group = file.group.rjust(max_length[:group])
    file_size = file.filesize.to_s.rjust(max_length[:filesize])
    time = file.mtime.strftime('%m %d %H:%M')
    filename = file.file
    puts "#{permission}  #{hard_link} #{user}  #{group}  #{file_size} #{time} #{filename} "
  end

  def maximums(file_stats)
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
