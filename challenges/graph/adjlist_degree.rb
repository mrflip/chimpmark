#!/usr/bin/env ruby

require 'rubygems'
require 'wukong'
require 'wukong/script/emr_command'

class AdjacencyListToDegree < Wukong::Streamer::RecordStreamer

  def recordize line
    id, nbrs = line.split(/\W+/, 2)
    [id, nbrs]
  end

  def process id, nbrs
    return if id.blank? || nbrs.blank?
    yield [id, nbrs.split(/\W+/).count]
  end
end

Wukong::Script.new(AdjacencyListToDegree, nil).run
