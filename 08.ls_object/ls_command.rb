#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'file_info'
require_relative 'file_permission'
require_relative 'file_list'

params = {}
OptionParser.new do |opt|
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)
end

file_list = FileList.new(params)
file_list.display_lists
