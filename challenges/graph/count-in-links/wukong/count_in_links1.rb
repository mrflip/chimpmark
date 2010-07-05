require 'rubygems'
require 'wukong'
class Array
 def sum
  x = 0
  each {|l| x+=l}
  return x
 end
end

# This was largely stolen from wukong example scripts, but the point of this module
# is to count the in-links to all of the pages on wikipedia.
module CountInLinks
  class Mapper < Wukong::Streamer::LineStreamer
    attr_accessor :link_count

    def initialize *args
      # set up a local cache for this chunk
      self.link_count = {}
    end

    def stream *args
      super *args
      self.link_count.each do |key, count|
        emit [key, "",count].to_flat
      end
    end

    def process line
      to_id = line.strip.split(/\s+/)[1]
      link_count[to_id] ||=0
      link_count[to_id] += 1
    end

  end

  class GroupByReducer < Wukong::Streamer::AccumulatingReducer
    attr_accessor :sum

    # Start with an empty sum
    def start! *args
      self.sum = 0
    end

    # Accumulate value in turn
    def accumulate key, count, value
      self.sum += value.to_i
    end

    def finalize
      yield [key, "\t\t#{sum}"]
    end
  end
end

Wukong::Script.new(
  CountInLinks::Mapper,
  CountInLinks::GroupByReducer
  ).run # Execute the script
