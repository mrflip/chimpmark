#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'

#
# ChimpMARK-2010 -- meta/prepare/wikidump/flatten_xml.rb
#
# Flattens the wikipedia 'enwiki-latest-pages-articles.xml.gz' into a
# one-line-per-record heap.
#
#    bin/prepare/wikidump/flatten_xml.rb --rm --run /data/source/wikidata/wikidump/enwiki-latest-pages-articles.xml.gz /data/rawd/wikidump/articles.xml
#

class FlattenXml < Wukong::Streamer::LineStreamer
  START_OF_RECORD=%r{\A\s*<page>}
  END_OF_RECORD=%r{\A\s*</page>}
  attr_accessor :in_record

  def initialize *args
    super *args
    self.in_record = false
  end

  #
  # Set the XML tag to use in the constants START_OF_RECORD and END_OF_RECORD
  #
  # This will output the content between each start/end pair in a single line
  # and eliminate content not enclosed in a start/end pair
  #
  # This makes NO ATTEMPT at parsing or at any kind of smart behavior --
  # it does something simple and stupid that happens to work because of the
  # special format of the one file it's meant to process.
  #
  def process line
    case
    when (line =~ START_OF_RECORD)
      puts "\n!!!#{in_record.inspect}\n" if self.in_record
      line.gsub!(/^\s+/,'')
      print line.chomp
      self.in_record = true
    when (line =~ END_OF_RECORD)
      puts line
      self.in_record = false
    else
      print(line.chomp, '&#10;') if self.in_record
    end
  end
end

# Execute the script
Wukong::Script.new(
  FlattenXml,
  nil
  ).run
