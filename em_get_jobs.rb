require 'eventmachine'
$LOAD_PATH << Dir.pwd
$LOAD_PATH << Dir.pwd + '/lib'
require 'queue_stat/loader'
ENV['RACK_ENV'] ||= 'prod'
EventMachine.run do
  EventMachine.add_periodic_timer(60) do 
    EventMachine.defer do
      Qstat::Loader.load_jobs
    end
  end

  require 'app' # Does not work as bare Sinatra app is not started.
  QueueStats.run!( :port=>3000 )
end

