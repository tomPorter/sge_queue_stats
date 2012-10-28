require_relative 'data_mapper/setup'
require_relative 'summary'
require_relative 'detail'
module Qstat
  class Loader
    def Loader.load_jobs()
      puts "Started load at #{Time.now}."
      qsids = Summary.new
      qsids.load_job_details!
      puts "  Started transaction at #{Time.now}."
      Job.transaction do |t|
        Job.all.destroy!
        Error.all.destroy!
        qsids.each { |qsid| Loader.create_job(qsid) }
      end  
      puts "  Ended transaction at #{Time.now}."
      puts "Finished load at #{Time.now}."
    end

    private
    def Loader.create_job(qsid)
      error_reason = qsid.delete(:error_reason)
      j = Job.new(qsid)
      j.error = Error.new(:error_message => error_reason) if ['Eqw','Ehqw','EhRqw'].include? qsid[:state]
      j.save
    end
  end
end
