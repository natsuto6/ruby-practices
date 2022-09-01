# !/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  files = ARGV
  options = { l: true, w: true, c: true } if options.empty?
  word_counts = files.empty? ? [build_count(options, $stdin.read)] : files_count(options, files)
  puts format(options, word_counts)
end

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-c') { |v| options[:c] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.parse!(ARGV)
  options
end

def build_count(options, text, filename: '')
  counts = {}
  counts[:l] = text.count("\n") if options[:l]
  counts[:w] = text.split(/\s+/).size if options[:w]
  counts[:c] = text.bytesize if options[:c]
  counts[:filename] = filename
  counts
end

def files_count(options, files)
  counts = files.map do |file|
    text = File.read(file)
    build_count(options, text, filename: file)
  end
  counts << total_count(counts) if files.size >= 2
  counts
end

def total_count(word_counts)
  {
    l: word_counts.sum { |count| count[:l] },
    w: word_counts.sum { |count| count[:w] },
    c: word_counts.sum { |count| count[:c] },
    filename: 'total'
  }
end

def format(options, word_counts)
  word_counts.map do |wc|
    counts = ''
    options.each_key { |key| counts += wc[key].to_s.rjust(8) if options[key] }
    counts += " #{wc[:filename]}"
  end
end

main
