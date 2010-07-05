require 'rubygems'
require 'wukong'

module CountInLinks
  class SpliceReducer < Wukong::Streamer::AccumulatingReducer         
    attr_accessor :columns            
    # reset the columnts to empty
    def start! *args        
      self.columns = []
    end
    def recordize line
      line.split(/\t/) rescue nil
    end
    def accumulate *args
      #puts args.join("-")
      args.each_index do |i|
        self.columns[i] = args[i] if !columns[i] || args[i].length > columns[i].length
      end
    end
    def finalize   
      yield self.columns
    end
  end 
end

Wukong::Script.new(
  nil,
  CountInLinks::SpliceReducer
  ).run # Execute the script
