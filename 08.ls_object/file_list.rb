# frozen_string_literal: true

class FileList
  def initialize(params)
    @params = params
  end

  def display_lists
    current_files = Dir.glob('*', @params[:a] ? File::FNM_DOTMATCH : 0)
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
    line_count = (lists.length.to_f / column).ceil
    line_count.times do |line|
      lists.each_slice(line_count) do |columns|
        print columns[line]&.ljust(16)
      end
      print "\n"
    end
  end

  def total_block_number(current_files)
    total = current_files.map { |file| FileInfo.new(file).stat.blocks }
    puts "total #{total.sum}"
  end

  def display_file_details(file, files)
    file_info = FileInfo.new(file)
    max_length = maximums(files)
    permission = file_info.permissions
    hard_link = file_info.hard_link_length.to_s.rjust(max_length[:hard_link])
    user = Etc.getpwuid(File.stat(file).uid).name.rjust(max_length[:user])
    group = Etc.getgrgid(File.stat(file).gid).name.rjust(max_length[:group])
    file_size = File.stat(file).size.to_s.rjust(max_length[:filesize])
    time = file_info.mtime_formatted
    filename = file
    puts "#{permission}  #{hard_link} #{user}  #{group}  #{file_size} #{time} #{filename} "
  end

  def maximums(file_stats)
    lengths_list = file_stats.map do |file|
      {
        hard_link: FileInfo.new(file).hard_link_length,
        user: Etc.getpwuid(File.stat(file).uid).name.length,
        group: Etc.getgrgid(File.stat(file).gid).name.length,
        filesize: File.stat(file).size.to_s.length
      }
    end

    lengths_list.each_with_object({ hard_link: 0, user: 0, group: 0, filesize: 0 }) do |lengths_hash, max_lengths|
      lengths_hash.each do |key, value|
        max_lengths[key] = [max_lengths[key] || 0, value].max
      end
    end
  end
end
