class Job
  include DataMapper::Resource
  property :qsid, Serial
  property :clientcode,String
  property :jobid,String
  property :command,String, :length => 150
  property :state,String
  property :user,String
  property :start_date,String
  property :start_time,String
  property :run_time,String
  property :wait_qsid,String
  property :thread,String
  property :queue_name,String
  has 1, :error
end

