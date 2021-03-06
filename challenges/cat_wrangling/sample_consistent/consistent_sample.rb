#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'


Settings.define :sampling_fraction, :required => true, :description => 'The approximate portion of lines to retain -- a decimal fraction like --sampling_fraction=0.001'
Settings.define :sampling_slug, :description => "We don't want the digest to favor some part of the space on every run. The supplied slug is prepended to every line, which spreads the hash space around. The same slug + input should give the same output; supply the date (or sometime) to the runner to get a different consistent output on each run"

#
# Probabilistically emit some fraction of record/lines
#
# If the given record is emitted ever, it will always be emitted, and otherwise rejected
#
# Set the sampling fraction at the command line using the
#   --sampling_fraction=
# option: for example, to take a random 1/1000th of the lines in huge_files,
#  ./examples/sample_records.rb --sampling_fraction=0.001 --run huge_files sampled_files
#
class ConsistentSampler < Wukong::Streamer::LineStreamer
  include Wukong::Streamer::Filter

  #
  # floating-point number between 0 and 1 giving the fraction of lines to emit:
  # at sampling_fraction=1 all records are emitted, at 0 none are.
  #
  # Takes its value from a mandatory command-line option
  #
  def sampling_fraction
    @sampling_fraction ||= ( options[:sampling_fraction] && options[:sampling_fraction].to_f ) or
      raise "Please supply a --sampling_fraction= argument, a decimal number between 0 and 1"
  end

  #
  # randomly decide to emit +sampling_fraction+ fraction of lines
  #
  def emit? line
    rand < self.sampling_fraction
  end
end

#
# Executes the script
#
Wukong::Script.new( Mapper,
  nil,
  :reduce_tasks => 0,
  :reuse_jvms   => true
  ).run
