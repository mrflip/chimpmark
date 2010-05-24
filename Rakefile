require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chimpmark"
    gem.summary = %Q{ChimpMARK-2010 is a collection of massive real-world datasets, interesting real-world problems, and simple example code to solve them. Learn Big Data processing, benchmark your cluster, or compete on implementation!}
    gem.description = %Q{ChimpMARK-2010 is a collection of massive real-world datasets, interesting real-world problems, and simple example code to solve them. Learn Big Data processing, benchmark your cluster, or compete on implementation!}
    gem.email = "coders@infochimps.org"
    gem.homepage = "http://github.com/infochimps/chimpmark"
    gem.authors = ["Philip (flip) Kromer"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
