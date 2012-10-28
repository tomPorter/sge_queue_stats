require 'date'
module Qstat
  JOB_STATES = ['qw','hqw','hRwq','r','t','Rr','Rt','s','ts','S','tS','T','tT','Rs','Rts','RS','RtS','RT','RtT','Eqw','Ehqw','EhRqw','dr','dt','dRr','dRt','ds','dS','dT','dRs','dRS','dRT']
	class BadQstatLineError < Exception
	end
	
	class NoDetailDataFoundError < Exception
	end
	
  class Detail < Hash
    def initialize(qstat_line)
     self.merge!(gen_job_hash(qstat_line))
    end

    #private
    def gen_job_hash(qstat_line)
      tokens = qstat_line.split()
      raise BadQstatLineError if tokens.size < 8
      raise BadQstatLineError unless JOB_STATES.include? tokens[4]
	    
      ph = {}
      ph[:qsid],ph[:user],ph[:state],ph[:start_date],ph[:start_time], ph[:thread] = tokens[0],tokens[3],tokens[4],tokens[5],tokens[6],tokens[-1]
      ph[:run_time] = get_run_time(ph[:start_date],ph[:start_time])  if ['r','s'].include? ph[:state] 
      ph[:queue_name],ph[:system] = get_queue_and_system(tokens)
      ph.delete(:system)   #Not needed at this time.
      ph.merge!(get_details(ph[:qsid])) 
      ph
    end

    def get_run_time(start_date,start_time)
      dtn = DateTime.now
      offset = dtn.zone.to_s
      sd = DateTime.strptime("#{start_date} #{start_time} #{offset}","%m/%d/%Y %H:%M:%S %z")
      num_of_days = dtn - sd
      if num_of_days < 0
        num_of_days = 0
      end
      num_of_minutes = (num_of_days * 24 * 60).to_i
      hours = "%03i" % (num_of_minutes.div 60)
      minutes = "%02i" % (num_of_minutes % 60)
      "#{hours}:#{minutes}"
    end

    def get_queue_and_system(tokens)
      if tokens.size == 9                                     
        queue_name,system = tokens[7].split('@')
      else
        queue_name,system = '',''
      end
    end

    def get_details(qsid)
      cmd = "qstat -j #{qsid} 2>&1"
      job_detail_lines = CommandRunner.run(cmd)
      ## >> ToDo: Verify whether structure changes depending on state and
      ## >> ToDo: make needed changes for captures. 
			if job_detail_lines.size > 2
        build_detail_hash job_detail_lines 
			else
				raise NoDetailDataFoundError
			end
    end

    def gen_detail_hash(line)  
      h = {}
      k,v = line.strip.split($;,2)
      case k
        when 'jid_predecessor_list'
          tokens = v.split($;,2)
          h[:wait_qsid] = tokens[1]
        when 'error'
          tokens = v.split($;,3)
          h[:error_reason] = tokens[2]
        when 'context:'
          tokens =  v.split(',')
          tokens.each do |t|
            tk,tv = t.split('=')
            h[tk.to_sym] = tv if ['jobid','clientcode','thread'].include? tk
          end
        else
          h[k.chop.to_sym] = v
      end
      h
    end
    def is_needed?(line)
      k,v = line.strip.split()
      #['jid_predecessor_list','error','cwd:','job_name:','context:'].include? k
      ['jid_predecessor_list','error','cwd:','job_name:','context:','hard_queue_list:'].include? k
    end

    def build_detail_hash(detail_lines)
      gh = {}
      detail_lines.shift
      needed_lines = detail_lines.select {|line| is_needed? line }
      needed_lines.each { |line| gh.merge!(gen_detail_hash(line)) }
      if gh.has_key?(:hard_queue_list)
        gh[:queue_name] = gh[:hard_queue_list]
        gh.delete :hard_queue_list
      end
      if gh.has_key?(:cwd) and gh.has_key?(:job_name)
        cmd = gh[:cwd] + '/' + gh[:job_name]
        gh[:command] = cmd
      end
      gh.delete :cwd
      gh.delete :job_name
      gh
    end

  end
end
