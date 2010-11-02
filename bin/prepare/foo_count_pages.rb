#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'

class CountPages < Wukong::Streamer::LineStreamer
  def process line
    yield line if line =~ %r{<page>}o
  end
end

# Execute the script
Wukong::Script.new(
  CountPages,
  nil
  ).run
