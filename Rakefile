$LOAD_PATH << 'lib'
require 'rake'
require 'queue_stat'
namespace :test do
  require 'rake/testtask'
  desc "Run rack tests"
  task :test do
	  Dir['test/*rb'].sort.each do |test| 
      load test 
    end
  end
end
task :default => 'test:test'
